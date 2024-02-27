export interface User {
    id: string;
    name: string;
    email: string;
    password: string;
    is_verified: boolean;
    role: string;
    created_at: string;
    updated_at: string | null;
}

export interface Recipe {
    id: string;
    user_id: string;
    is_public: boolean;
    body: string;
    created_at: string;
    updated_at: string | null;
}

export interface UserFavorite {
    recipe_id: string;
    user_id: string;
}

export interface Ingredient {
    id: string;
    name: string;
}

export interface RecipeIngredient {
    recipe_id: string;
    ingredient_id: string;
}

export interface Comment {
    id: string;
    recipe_id: string;
    user_id: string;
    parent_id: string | null;
    body: string;
    created_at: string;
    updated_at: string | null;
}
