import bcrypt from 'bcrypt';
import { faker } from '@faker-js/faker';
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from '../db/schema';
import {
	users,
	movies,
	watchlists,
	watchlistMovies,
	favorites,
	movieReviews,
	posts,
	postLikes,
	postComments,
} from '../db/schema';

// Load environment variables
import dotenv from 'dotenv';
dotenv.config();

console.log('DATABASE_URL exists:', !!process.env.DATABASE_URL);
console.log('DATABASE_URL preview:', process.env.DATABASE_URL?.slice(0, 20) + '...');

// Create a dedicated connection for seeding with better configuration
const client = postgres(process.env.DATABASE_URL!, {
	max: 1, // Use only one connection for seeding
	idle_timeout: 20,
	connect_timeout: 60,
});
const db = drizzle(client, { schema });

async function main() {
	// 1. Create a dummy user
	const passwordHash = await bcrypt.hash('password123', 10);
	const userResult = await db
		.insert(users)
		.values({
			name: faker.person.fullName(),
			username: faker.internet.username(),
			email: faker.internet.email(),
			password: passwordHash,
			avatar: faker.image.avatar(),
			role: 'user',
			isEmailVerified: true,
		})
		.returning();

	const user = userResult[0];
	console.log('Inserted user:', user);

	// 2. Seed 10 movies for the user
	const movieData = [];
	for (let i = 1; i <= 10; i++) {
		const movieResult = await db
			.insert(movies)
			.values({
				title: faker.lorem.words({ min: 1, max: 4 }),
				tmdbId: faker.string.numeric(6),
				posterPath: faker.image.urlPicsumPhotos({ width: 500, height: 750 }),
				releaseDate: faker.date.past({ years: 10 }).toISOString().split('T')[0],
				overview: faker.lorem.paragraph(),
				rating: faker.number.int({ min: 1, max: 10 }),
				userId: user.id,
				genres: faker.helpers
					.arrayElements(
						['Action', 'Drama', 'Comedy', 'Thriller', 'Sci-Fi', 'Romance'],
						2
					)
					.join(','),
			})
			.returning();

		const movie = movieResult[0];
		movieData.push(movie);
		if (i === 1) console.log('Inserted first movie:', movie);
	} // 3. Seed 1 watchlist for the user
	// 3. Seed 1 watchlist for the user
	const watchlistResult = await db
		.insert(watchlists)
		.values({
			userId: user.id,
			name: faker.lorem.words({ min: 1, max: 3 }),
			description: faker.lorem.sentence(),
			isPublic: true,
		})
		.returning();

	const watchlist = watchlistResult[0];
	console.log('Inserted watchlist:', watchlist);

	// 4. Add 10 movies to the watchlist
	for (let i = 0; i < 10; i++) {
		await db.insert(watchlistMovies).values({
			watchlistId: watchlist.id,
			movieId: movieData[i].id,
		});
	}
	console.log('Inserted 10 watchlistMovies');

	// 5. Seed 10 favorites for the user
	for (let i = 0; i < 10; i++) {
		await db.insert(favorites).values({
			userId: user.id,
			movieId: movieData[i].id,
		});
	}
	console.log('Inserted 10 favorites');

	// 6. Seed 10 movie reviews for the user
	for (let i = 0; i < 10; i++) {
		await db.insert(movieReviews).values({
			userId: user.id,
			movieId: movieData[i].id,
			content: faker.lorem.sentences({ min: 1, max: 3 }),
			rating: faker.number.int({ min: 1, max: 10 }),
			isPublic: true,
		});
	}
	console.log('Inserted 10 movieReviews');

	// 7. Seed 10 posts for the user
	const postData = [];
	for (let i = 1; i <= 10; i++) {
		const postResult = await db
			.insert(posts)
			.values({
				userId: user.id,
				tmdbId: faker.string.numeric(6),
				posterPath: faker.image.urlPicsumPhotos({ width: 500, height: 750 }),
				title: faker.lorem.words({ min: 2, max: 5 }),
				content: faker.lorem.paragraphs({ min: 1, max: 2 }),
				isPublic: true,
			})
			.returning();

		const post = postResult[0];
		postData.push(post);
		if (i === 1) console.log('Inserted first post:', post);
	}

	// 8. Seed 10 post likes for the user
	for (let i = 0; i < 10; i++) {
		await db.insert(postLikes).values({
			userId: user.id,
			postId: postData[i].id,
		});
	}
	console.log('Inserted 10 postLikes');

	// 9. Seed 10 post comments for the user
	for (let i = 0; i < 10; i++) {
		await db.insert(postComments).values({
			userId: user.id,
			postId: postData[i].id,
			content: faker.lorem.sentences({ min: 1, max: 2 }),
		});
	}
	console.log('Inserted 10 postComments');

	console.log('Seeding complete!');
}

main()
	.then(() => {
		console.log('Database seeding completed successfully!');
		process.exit(0);
	})
	.catch((err) => {
		console.error('Seeding failed:', err);
		process.exit(1);
	})
	.finally(() => {
		client.end();
	});
