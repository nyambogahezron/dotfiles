import * as schema from './schema';
import { sql } from 'drizzle-orm';
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({
	connectionString: process.env.DATABASE_URL,
});
const db = drizzle({ client: pool });

function testDbConnection() {
	try {
		db.execute(sql`SELECT 1`);
		console.log('Database connection successful');
	} catch (error) {
		console.error('Database connection failed:', error);
	}
}

testDbConnection();

export { schema };
