import { client, db, resetTestDatabase } from '../db/test-db';
import { migrate } from 'drizzle-orm/postgres-js/migrator';
import { sql } from 'drizzle-orm';

// Setup function to run before all tests
export async function setupTestDatabase() {
	try {
		const { db: freshDb } = await resetTestDatabase();

		// PostgreSQL doesn't need PRAGMA foreign_keys like SQLite
		await migrate(freshDb, { migrationsFolder: './db/migrations' });
	} catch (error) {
		console.error('Error setting up test database:', error);
		throw error;
	}
}

export async function teardownTestDatabase() {
	try {
		if (client) {
			await client.end();
		}
	} catch (error) {
		console.error('Error tearing down test database:', error);
	}
}
