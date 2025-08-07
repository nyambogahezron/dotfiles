import * as schema from './schema';
import { sql } from 'drizzle-orm';
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

const client = postgres(process.env.DATABASE_URL!);
export const db = drizzle(client, { schema });

async function testDbConnection() {
	try {
		await db.execute(sql`SELECT 1`);
		console.log('Database connection successful');
	} catch (error) {
		console.error('Database connection failed:', error);
	}
}

testDbConnection();

export { schema };
