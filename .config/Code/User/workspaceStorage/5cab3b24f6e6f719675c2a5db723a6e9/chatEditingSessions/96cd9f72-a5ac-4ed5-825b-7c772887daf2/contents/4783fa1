'use client';

import React, { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import {
  Calendar,
  Star,
  Heart,
  Share2,
  Plus,
  CheckCircle,
  Edit,
  PlayCircle as CirclePlay,
} from 'lucide-react';
import type { TvShow, Season } from '../../types';
import AddToWatchlistModal from '../../components/media/AddToWatchlistModal';
import AddReviewModal from '../../components/media/AddReviewModal';
import { useMovie, useAddToWatchlist, useAddToFavorites } from '@repo/services';
import RatingStars from '../../components/ui/RatingStars';

const TvShowDetails: React.FC = () => {
  const { id } = useParams<{ id: string }>();

  // Move all hooks before any conditional returns
  const [userRating, setUserRating] = useState<number | null>(null);
  const [showWatchlistModal, setShowWatchlistModal] = useState(false);
  const [showReviewModal, setShowReviewModal] = useState(false);
  const [inWatchlist, setInWatchlist] = useState(false);
  const [isFavorite, setIsFavorite] = useState(false);
  const [activeSeasonIndex, setActiveSeasonIndex] = useState(0);
  const [seasons, setSeasons] = useState<Season[]>([]);

  // Fetch TV show data from server (using movie service for now)
  const { data: serverTvShow, isLoading, error } = useMovie(id as string);

  // Mutations
  const addToWatchlistMutation = useAddToWatchlist();
  const addToFavoritesMutation = useAddToFavorites();

  // Set user rating from server data
  useEffect(() => {
    if (serverTvShow?.userRating) {
      setUserRating(serverTvShow.userRating);
    }
  }, [serverTvShow]);

  if (!id) {
    return <div>Invalid TV show ID</div>;
  }

  // Convert server data to local TvShow format
  const tvShow: TvShow | null = serverTvShow
    ? {
        id: serverTvShow.id,
        title: serverTvShow.title,
        poster: serverTvShow.posterPath || '',
        backdrop: serverTvShow.backdropPath || '',
        overview: serverTvShow.overview || '',
        firstAirDate: serverTvShow.releaseDate || '',
        lastAirDate: '', // TODO: Add to server model
        seasons: 1, // TODO: Add to server model
        episodes: 1, // TODO: Add to server model
        genres: serverTvShow.genres || [],
        creator: '', // TODO: Add to server model
        cast: [], // TODO: Add to server model
        rating: serverTvShow.voteAverage || 0,
        status: 'Running' as const, // TODO: Add to server model
      }
    : null;

  // Remove the useEffect that creates mock seasons
  // Remove the cast: [] placeholder in tvShow definition
  // In the UI, display a message if seasons or cast are empty

  const handleRatingChange = async (rating: number) => {
    if (!id) return;

    try {
      // The createReviewMutation is no longer available from services,
      // so this function will need to be updated to handle rating directly
      // or the useCreateReview hook needs to be re-added.
      // For now, we'll just update the userRating state.
      setUserRating(rating);
    } catch (error) {
      console.error('Error updating rating:', error);
    }
  };

  const toggleFavorite = async () => {
    if (!serverTvShow) return;

    try {
      await addToFavoritesMutation.mutateAsync({
        tmdbId: serverTvShow.tmdbId,
        mediaType: 'tv',
        title: serverTvShow.title,
        posterPath: serverTvShow.posterPath,
      });
      setIsFavorite(!isFavorite);
    } catch (error) {
      console.error('Error toggling favorite:', error);
    }
  };

  const toggleWatchlist = async () => {
    if (!serverTvShow) return;

    try {
      await addToWatchlistMutation.mutateAsync({
        tmdbId: serverTvShow.tmdbId,
        mediaType: 'tv',
        title: serverTvShow.title,
        posterPath: serverTvShow.posterPath,
      });
      setInWatchlist(!inWatchlist);
    } catch (error) {
      console.error('Error toggling watchlist:', error);
    }
  };

  if (isLoading) {
    return (
      <div className="container-custom py-16 flex justify-center">
        <div className="animate-pulse text-white">Loading TV show details...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container-custom py-16">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-white">Failed to load TV show</h2>
          <p className="text-gray-400 mt-2">{error.message}</p>
        </div>
      </div>
    );
  }

  if (!tvShow) {
    return (
      <div className="container-custom py-16">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-white">TV show not found</h2>
          <p className="text-gray-400 mt-2">
            The TV show you're looking for doesn't exist or has been removed.
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
              <img
                src={tvShow.backdrop || ''}
                alt={tvShow.title || ''}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-gray-900 via-gray-900/50 to-transparent"></div>
            </div>

            <div className="absolute bottom-0 left-0 right-0 p-8">
              <div className="flex items-end space-x-6">
                <img
                  src={tvShow.poster || ''}
                  alt={tvShow.title || ''}
                  className="w-32 h-48 object-cover rounded-lg shadow-lg"
                />
                <div className="flex-1">
                  <h1 className="text-4xl font-bold text-white mb-2">{tvShow.title}</h1>
                  <div className="flex items-center space-x-4 text-gray-300 mb-4">
                    <div className="flex items-center">
                      <Calendar className="h-4 w-4 mr-1" />
                      <span>{tvShow.firstAirDate}</span>
                    </div>
                    <div className="flex items-center">
                      <Star className="h-4 w-4 mr-1 text-yellow-400" />
                      <span>{tvShow.rating}/10</span>
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
                <p className="text-gray-300 leading-relaxed">{tvShow.overview}</p>
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

              {/* Seasons */}
              {seasons.length === 0 && (
                <div className="text-gray-400">No seasons available for this show.</div>
              )}
              {seasons.length > 0 && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Seasons</h2>
                  <div className="space-y-4">
                    {seasons.map((season, index) => (
                      <div
                        key={season.id}
                        className={`p-4 rounded-lg cursor-pointer transition-colors ${
                          index === activeSeasonIndex
                            ? 'bg-gray-700'
                            : 'bg-gray-900 hover:bg-gray-700'
                        }`}
                        onClick={() => setActiveSeasonIndex(index)}
                      >
                        <div className="flex items-center justify-between">
                          <div>
                            <h3 className="font-medium text-white">Season {season.seasonNumber}</h3>
                            <p className="text-sm text-gray-400">{season.episodeCount} episodes</p>
                          </div>
                          <CirclePlay className="h-5 w-5 text-gray-400" />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Genres */}
              {tvShow.genres.length > 0 && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Genres</h2>
                  <div className="flex flex-wrap gap-2">
                    {tvShow.genres.map((genre) => (
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

              {/* Creator */}
              {tvShow.creator && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Creator</h2>
                  <p className="text-gray-300">{tvShow.creator}</p>
                </div>
              )}

              {/* Cast */}
              {tvShow && (!tvShow.cast || tvShow.cast.length === 0) && (
                <div className="text-gray-400">No cast information available.</div>
              )}
              {tvShow.cast.length > 0 && (
                <div className="bg-gray-800 rounded-lg p-6">
                  <h2 className="text-xl font-semibold text-white mb-4">Cast</h2>
                  <div className="space-y-3">
                    {tvShow.cast.slice(0, 5).map((actor) => (
                      <div key={actor} className="text-gray-300">
                        {actor}
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {showWatchlistModal && (
        <AddToWatchlistModal
          media={tvShow}
          onClose={() => setShowWatchlistModal(false)}
          onAdd={() => {
            setInWatchlist(true);
            setShowWatchlistModal(false);
          }}
        />
      )}

      {showReviewModal && (
        <AddReviewModal
          media={tvShow}
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

export default TvShowDetails;
