import pg from "pg";
import config from "../config";

const pool = new pg.Pool(config.pg);

interface PGResponse extends pg.QueryResult {
    insertId?: string;
}

export const Query = <T = PGResponse>(sql: string, vals: unknown[] = []) => {
    return new Promise((resolve, reject) => {
        pool.query(sql, vals, (err, data) => {
            if (err) {
                reject(err);
            } else {
                if (data.command === "SELECT") {
                    resolve(data.rows as T);
                } else if (data.command === "INSERT") {
                    if (data.rows[0]?.id) {
                        resolve({ ...data, insertId: data.rows[0].id } as T);
                    } else {
                        resolve(data as T);
                    }
                } else {
                    resolve(data as T);
                }
            }
        });
    });
};
