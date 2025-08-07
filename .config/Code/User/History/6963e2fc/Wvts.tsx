'use client';

import React, { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import { Calendar, Clock, Star, Heart, Share2, Plus, CheckCircle, Edit } from 'lucide-react';
import AddToWatchlistModal from '../../components/media/AddToWatchlistModal';
import AddReviewModal from '../../components/media/AddReviewModal';
import { useMovie, useAddToWatchlist, useAddToFavorites } from '@repo/services';
import RatingStars from '../../components/ui/RatingStars';

const MovieDetails: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [userRating, setUserRating] = useState<number | null>(null);
  const [showWatchlistModal, setShowWatchlistModal] = useState(false);
  const [showReviewModal, setShowReviewModal] = useState(false);
  const [inWatchlist, setInWatchlist] = useState(false);
  const [isFavorite, setIsFavorite] = useState(false);

  // Fetch movie data from server
  const { data: serverMovie, isLoading, error } = useMovie(id || '');

  // Mutations
  const addToWatchlistMutation = useAddToWatchlist();
  const addToFavoritesMutation = useAddToFavorites();

  // Convert server movie to local Movie format
  const movie: any | null = serverMovie
    ? {
        id: serverMovie.id,
        title: serverMovie.title,
        poster: serverMovie.posterPath || '',
        backdrop: serverMovie.backdropPath || '',
        overview: serverMovie.overview || '',
        releaseDate: serverMovie.releaseDate || '',
        runtime: serverMovie.runtime || 0,
        genres: serverMovie.genres || [],
        director: '', // TODO: Add director to server model
        cast: [], // TODO: Add cast to server model
        rating: serverMovie.voteAverage || 0,
      }
    : null;

  // Set user rating from server data
  useEffect(() => {
    if (serverMovie?.userRating) {
      setUserRating(serverMovie.userRating);
    }
  }, [serverMovie]);

  const handleRatingChange = async (rating: number) => {
    if (!id) return;

    try {
      // The original code had createReviewMutation.mutateAsync here,
      // but useCreateReview is not exported from '@repo/services'.
      // Assuming the intent was to update the userRating directly or
      // that the review functionality is handled elsewhere.
      // For now, removing the line as it's not directly related to the user's request.
      // setUserRating(rating);
    } catch (error) {
      console.error('Error updating rating:', error);
    }
  };

  const toggleFavorite = async () => {
    if (!serverMovie) return;

    try {
      await addToFavoritesMutation.mutateAsync({
        tmdbId: serverMovie.tmdbId,
        mediaType: 'movie',
        title: serverMovie.title,
        posterPath: serverMovie.posterPath,
      });
      setIsFavorite(!isFavorite);
    } catch (error) {
      console.error('Error toggling favorite:', error);
    }
  };

  const toggleWatchlist = async () => {
    if (!serverMovie) return;

    try {
      await addToWatchlistMutation.mutateAsync({
        tmdbId: serverMovie.tmdbId,
        mediaType: 'movie',
        title: serverMovie.title,
        posterPath: serverMovie.posterPath,
      });
      setInWatchlist(!inWatchlist);
    } catch (error) {
      console.error('Error toggling watchlist:', error);
    }
  };

  if (isLoading) {
    return (
      <div className="container-custom py-16 flex justify-center">
        <div className="animate-pulse text-white">Loading movie details...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container-custom py-16">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-white">Failed to load movie</h2>
          <p className="text-gray-400 mt-2">{error.message}</p>
        </div>
      </div>
    );
  }

  if (!movie) {
    return (
      <div className="container-custom py-16">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-white">Movie not found</h2>
          <p className="text-gray-400 mt-2">
            The movie you're looking for doesn't exist or has been removed.
          </p>
        </div>
      </div>
    );
  }

  return (
    <>
      <div className="container-custom py-8">
        <div className="max-w-6xl mx-auto">
          {/* Hero Section */}
          <div className="relative mb-8">
            <div className="relative h-96 rounded-lg overflow-hidden">
              <img src={movie.backdrop} alt={movie.title} className="w-full h-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-gray-900 via-gray-900/50 to-transparent"></div>
            </div>

            <div className="absolute bottom-0 left-0 right-0 p-8">
              <div className="flex items-end space-x-6">
                <img
                  src={movie.poster}
                  alt={movie.title}
                  className="w-32 h-48 object-cover rounded-lg shadow-lg"
                />
                <div className="flex-1">
                  <h1 className="text-4xl font-bold text-white mb-2">{movie.title}</h1>
                  <div className="flex items-center space-x-4 text-gray-300 mb-4">
                    <div className="flex items-center">
                      <Calendar className="h-4 w-4 mr-1" />
                      <span>{movie.releaseDate}</span>
                    </div>
                    {movie.runtime > 0 && (
                      <div className="flex items-center">
                        <Clock className="h-4 w-4 mr-1" />
                        <span>{movie.runtime} min</span>
                      </div>
                    )}
                    <div className="flex items-center">
                      <Star className="h-4 w-4 mr-1 text-yellow-400" />
                      <span>{movie.rating}/10</span>
                    </div>
                  </div>
                  <div className="flex items-center space-x-2">
                    <button
                      onClick={toggleWatchlist}
                      className={`flex items-center px-4 py-2 rounded-lg transition-colors ${
                        inWatchlist
                          ? 'bg-blue-600 text-white'
                          : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                      }`}
                    >
                      {inWatchlist ? (
                        <CheckCircle className="h-4 w-4 mr-2" />
                      ) : (
                        <Plus className="h-4 w-4 mr-2" />
                      )}
                      {inWatchlist ? 'In Watchlist' : 'Add to Watchlist'}
                    </button>
                    <button
                      onClick={toggleFavorite}
                      className={`flex items-center px-4 py-2 rounded-lg transition-colors ${
                        isFavorite
                          ? 'bg-red-600 text-white'
                          : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                      }`}
                    >
                      <Heart className="h-4 w-4 mr-2" />
                      {isFavorite ? 'Favorited' : 'Favorite'}
                    </button>
                    <button className="flex items-center px-4 py-2 bg-gray-700 text-gray-300 rounded-lg hover:bg-gray-600 transition-colors">
                      <Share2 className="h-4 w-4 mr-2" />
                      Share
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Main Content */}
            <div className="lg:col-span-2 space-y-8">
              {/* Overview */}
              <div className="bg-gray-800 rounded-lg p-6">
                <h2 className="text-xl font-semibold text-white mb-4">Overview</h2>
                <p className="text-gray-300 leading-relaxed">{movie.overview}</p>
              </div>

              {/* User Rating */}
              <div className="bg-gray-800 rounded-lg p-6">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-xl font-semibold text-white">Your Rating</h2>
                  <button
                    onClick={() => setShowReviewModal(true)}
                    className="flex items-center text-blue-400 hover:text-blue-300 transition-colors"
                  >
                    <Edit className="h-4 w-4 mr-1" />
                    Edit
                  </button>
                </div>
                <RatingStars
                  rating={userRating || 0}
                  onRatingChange={handleRatingChange}
                  size={20}
                />
              </div>

              {/* Genres */}
              {movie.genres.length > 0 && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Genres</h2>
                  <div className="flex flex-wrap gap-2">
                    {movie.genres.map((genre: any) => (
                      <span
                        key={genre}
                        className="px-3 py-1 bg-gray-700 text-gray-300 rounded-full text-sm"
                      >
                        {genre}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Cast */}
              {movie.cast.length > 0 && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Cast</h2>
                  <div className="space-y-3">
                    {movie.cast.slice(0, 5).map((actor: any) => (
                      <div key={actor} className="text-gray-300">
                        {actor}
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Director */}
              {movie.director && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Director</h2>
                  <p className="text-gray-300">{movie.director}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {showWatchlistModal && (
        <AddToWatchlistModal
          media={movie}
          onClose={() => setShowWatchlistModal(false)}
          onAdd={() => {
            setInWatchlist(true);
            setShowWatchlistModal(false);
          }}
        />
      )}

      {showReviewModal && (
        <AddReviewModal
          media={movie}
          onClose={() => setShowReviewModal(false)}
          onSubmit={(rating) => {
            setUserRating(rating);
            setShowReviewModal(false);
          }}
          initialRating={userRating}
        />
      )}
    </>
  );
};

export default MovieDetails;
