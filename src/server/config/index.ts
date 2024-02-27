import dotenv from "dotenv";

dotenv.config();

const pg = {
    user: process.env.DB_USER as string,
    password: process.env.DB_PASSWORD as string,
    host: process.env.DB_HOST as string,
    database: process.env.DB_SCHEMA as string,
};

function hasUndefinedValues(configObj: { [key: string]: string | undefined }) {
    return Object.values(configObj).some((value) => typeof value === "undefined");
}

if (hasUndefinedValues(pg)) {
    const asterisks = new Array(59).fill("*").join("");

    console.log(`\n\n${asterisks}`);
    console.log(`***\tMissing Postgres environment variables\t***`);
    console.log(`***\tVerify that your .env file and config match\t***`);
    console.log(`${asterisks}\n\n`);

    process.exit(1);
}

export default {
    pg,
};
