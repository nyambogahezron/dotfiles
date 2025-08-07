import { defineConfig } from 'drizzle-kit';

export default defineConfig({
	dialect: 'postgresql', 
	schema: './db/schema.ts',
	out: './db/migrations',
	dbCredentials: {
		connectionString: process.env.DATABASE_URL || 'postgres://user:password@localhost:5432/mydb',
	},
	// Optional: specify the driver if needed
});
