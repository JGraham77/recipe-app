CREATE SCHEMA recipe_app;

CREATE TABLE users (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(64),
  email VARCHAR(128) UNIQUE,
  password CHAR(60),
  is_verified SMALLINT DEFAULT 0,
  role VARCHAR(16) DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE TABLE recipes (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  is_public SMALLINT DEFAULT 0,
  body VARCHAR(4096),
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE user_favorites (
	recipe_id UUID,
  user_id UUID,
  FOREIGN KEY (recipe_id) REFERENCES recipes(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (recipe_id, user_id)
);

CREATE TABLE ingredients (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(64) UNIQUE
);

CREATE TABLE recipe_ingredients (
	recipe_id UUID,
  ingredient_id UUID,
  FOREIGN KEY (recipe_id) REFERENCES recipes(id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(id),
  PRIMARY KEY (recipe_id, ingredient_id)
);

CREATE TABLE comments (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  recipe_id UUID,
  user_id UUID,
  parent_id UUID,
  body VARCHAR(4096),
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ,
  FOREIGN KEY (recipe_id) REFERENCES recipes(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES comments(id)
);


CREATE OR REPLACE FUNCTION reassign_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP; 
   RETURN NEW;
END;
$$ language 'plpgsql';


CREATE TRIGGER reassign_users_updated_at BEFORE UPDATE
    ON users FOR EACH ROW EXECUTE PROCEDURE 
    reassign_updated_at_column();
    
CREATE TRIGGER reassign_recipes_updated_at BEFORE UPDATE
    ON recipes FOR EACH ROW EXECUTE PROCEDURE 
    reassign_updated_at_column();
    
CREATE TRIGGER reassign_comments_updated_at BEFORE UPDATE
    ON comments FOR EACH ROW EXECUTE PROCEDURE 
    reassign_updated_at_column();
