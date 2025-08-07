const { createPool } = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config();
var globalPool = undefined;
const connection = async () => {
    try {
        if (globalPool) {
            console.log('database is connected');
            return globalPool;
        }
        globalPool = await createPool({
            host: process.env.BD_HOST,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            port: process.env.DB_PORT ? process.env.DB_PORT : 3306,
        });
        return globalPool;
    } catch (error) {
        throw error;
    }
};

const query = async (query, values) => {
    const pool = await connection();
    return (await pool.query(query, values))[0];
};

module.exports = {
    connection,
    query,
};
