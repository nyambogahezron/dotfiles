// Auth types
export interface ServerUser {
  id: string;
  email: string;
  username: string;
  firstName?: string;
  lastName?: string;
  avatar?: string;
  createdAt: string;
  updatedAt: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  username: string;
  email: string;
  password: string;
}

// Movie types
export interface ServerMovie {
  id: string;
  tmdbId: number;
  title: string;
  overview: string;
  releaseDate: string;
  posterPath?: string;
  backdropPath?: string;
  voteAverage: number;
  voteCount: number;
  genres: string[];
  runtime?: number;
  createdAt: string;
  updatedAt: string;
}

// Watchlist types
export interface ServerWatchlist {
  id: string;
  userId: string;
  movieId: string;
  status: 'want_to_watch' | 'watching' | 'watched';
  priority?: 'low' | 'medium' | 'high';
  notes?: string;
  addedAt: string;
  watchedAt?: string;
  movie: ServerMovie;
}

// Favorite types
export interface ServerFavorite {
  id: string;
  userId: string;
  movieId: string;
  addedAt: string;
  movie: ServerMovie;
}

// Review types
export interface ServerReview {
  id: string;
  userId: string;
  movieId: string;
  rating: number;
  review?: string;
  createdAt: string;
  updatedAt: string;
  movie: ServerMovie;
  user: ServerUser;
}
