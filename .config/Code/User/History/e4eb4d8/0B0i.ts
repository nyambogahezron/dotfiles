import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();
import bcrypt from 'bcrypt';
import { faker } from '@faker-js/faker';

async function main() {
	// 1. Create a dummy user
	const passwordHash = await bcrypt.hash('password123', 10);
	const user = await prisma.user.create({
		data: {
			name: faker.person.fullName(),
			username: faker.internet.userName(),
			email: faker.internet.email(),
			password: passwordHash,
			avatar: faker.image.avatar(),
			role: 'user',
			isEmailVerified: true,
		},
	});
	console.log('Inserted user:', user);

	// 2. Seed 10 movies for the user
	const movies = [];
	for (let i = 1; i <= 10; i++) {
		const movie = await prisma.movie.create({
			data: {
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
			},
		});
		movies.push(movie);
		if (i === 1) console.log('Inserted first movie:', movie);
	}

	// 3. Seed 1 watchlist for the user
	const watchlist = await prisma.watchlist.create({
		data: {
			userId: user.id,
			name: faker.lorem.words({ min: 1, max: 3 }),
			description: faker.lorem.sentence(),
			isPublic: true,
		},
	});
	console.log('Inserted watchlist:', watchlist);

	// 4. Add 10 movies to the watchlist
	for (let i = 0; i < 10; i++) {
		await prisma.watchlistMovie.create({
			data: {
				watchlistId: watchlist.id,
				movieId: movies[i].id,
			},
		});
	}
	console.log('Inserted 10 watchlistMovies');

	// 5. Seed 10 favorites for the user
	for (let i = 0; i < 10; i++) {
		await prisma.favorite.create({
			data: {
				userId: user.id,
				movieId: movies[i].id,
			},
		});
	}
	console.log('Inserted 10 favorites');

	// 6. Seed 10 movie reviews for the user
	for (let i = 0; i < 10; i++) {
		await prisma.movieReview.create({
			data: {
				userId: user.id,
				movieId: movies[i].id,
				content: faker.lorem.sentences({ min: 1, max: 3 }),
				rating: faker.number.int({ min: 1, max: 10 }),
				isPublic: true,
			},
		});
	}
	console.log('Inserted 10 movieReviews');

	// 7. Seed 10 posts for the user
	const posts = [];
	for (let i = 1; i <= 10; i++) {
		const post = await prisma.post.create({
			data: {
				userId: user.id,
				tmdbId: faker.string.numeric(6),
				posterPath: faker.image.urlPicsumPhotos({ width: 500, height: 750 }),
				title: faker.lorem.words({ min: 2, max: 5 }),
				content: faker.lorem.paragraphs({ min: 1, max: 2 }),
				isPublic: true,
			},
		});
		posts.push(post);
		if (i === 1) console.log('Inserted first post:', post);
	}

	// 8. Seed 10 post likes for the user
	for (let i = 0; i < 10; i++) {
		await prisma.postLike.create({
			data: {
				userId: user.id,
				postId: posts[i].id,
			},
		});
	}
	console.log('Inserted 10 postLikes');

	// 9. Seed 10 post comments for the user
	for (let i = 0; i < 10; i++) {
		await prisma.postComment.create({
			data: {
				userId: user.id,
				postId: posts[i].id,
				content: faker.lorem.sentences({ min: 1, max: 2 }),
			},
		});
	}
	console.log('Inserted 10 postComments');

	console.log('Seeding complete!');
	await prisma.$disconnect();
}

main().catch((err) => {
	console.error('Seeding failed:', err);
	process.exit(1);
});
