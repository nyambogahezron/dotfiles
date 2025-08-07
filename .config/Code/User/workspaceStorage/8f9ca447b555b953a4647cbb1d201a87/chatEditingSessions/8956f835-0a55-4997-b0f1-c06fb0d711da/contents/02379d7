import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema';

export const createTestClient = () => {
	// Use a test database URL or fallback to memory for testing
	const testUrl = process.env.TEST_DATABASE_URL || process.env.DATABASE_URL;
	return postgres(testUrl!);
};

let client = createTestClient();
export const db = drizzle(client, { schema });

export const resetTestDatabase = async () => {
	if (client) {
		try {
			await client.end();
		} catch (error) {
			console.error('Error closing test database connection:', error);
		}
	}

	client = createTestClient();

	const newDb = drizzle(client, { schema });

	Object.assign(db, newDb);

	return { db, client };
};

export { client };
