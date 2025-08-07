import React, { createContext, useContext } from 'react';
import type { ReactNode } from 'react';
import type { MediaEntry } from '../types';
import { WatchStatus } from '../types';
import { useUserMovies, useWatchlist, useFavorites } from '@repo/services';
import type { ServerMovie, ServerWatchlist, ServerFavorite } from '@repo/services';

interface EntryContextProps {
  entries: MediaEntry[];
  watchlist: MediaEntry[];
  recentlyWatched: MediaEntry[];
  addEntry: (entry: MediaEntry) => void;
  updateEntry: (id: string, updatedEntry: Partial<MediaEntry>) => void;
  removeEntry: (id: string) => void;
  isLoading: boolean;
  error: string | null;
}

const EntryContext = createContext<EntryContextProps | undefined>(undefined);

export const useEntryContext = () => {
  const context = useContext(EntryContext);
  if (!context) {
    throw new Error('useEntryContext must be used within an EntryProvider');
  }
  return context;
};

interface EntryProviderProps {
  children: ReactNode;
}

// Helper function to convert server data to MediaEntry format
const convertServerMovieToMediaEntry = (movie: ServerMovie): MediaEntry => {
  return {
    id: movie.id,
    title: movie.title,
    type: 'movie',
    poster: movie.posterPath || '',
    backdrop: movie.backdropPath || '',
    rating: movie.userRating || 0,
    status: movie.watchedAt ? WatchStatus.COMPLETED : WatchStatus.PLANNING,
    dateWatched: movie.watchedAt,
    review: movie.notes,
    notes: movie.notes,
    rewatches: 0, // TODO: Add rewatch tracking to server
    private: false, // TODO: Add privacy settings to server
    favorite: false, // This will be determined by favorites list
    createdAt: movie.createdAt,
    updatedAt: movie.updatedAt,
  };
};

const convertServerWatchlistToMediaEntry = (item: ServerWatchlist): MediaEntry => {
  return {
    id: item.id,
    title: item.title,
    type: item.mediaType,
    poster: item.posterPath || '',
    backdrop: '',
    rating: 0,
    status: WatchStatus.PLANNING,
    rewatches: 0,
    private: false,
    favorite: false,
    createdAt: item.createdAt,
    updatedAt: item.createdAt,
  };
};

const convertServerFavoriteToMediaEntry = (item: ServerFavorite): MediaEntry => {
  return {
    id: item.id,
    title: item.title,
    type: item.mediaType,
    poster: item.posterPath || '',
    backdrop: '',
    rating: 0,
    status: WatchStatus.COMPLETED, // Assuming favorites are watched
    rewatches: 0,
    private: false,
    favorite: true,
    createdAt: item.createdAt,
    updatedAt: item.createdAt,
  };
};

export const EntryProvider: React.FC<EntryProviderProps> = ({ children }) => {
  // Fetch data from server
  const { data: moviesData, isLoading: moviesLoading, error: moviesError } = useUserMovies();

  const {
    data: watchlistData,
    isLoading: watchlistLoading,
    error: watchlistError,
  } = useWatchlist();

  const {
    data: favoritesData,
    isLoading: favoritesLoading,
    error: favoritesError,
  } = useFavorites();

  // Convert server data to MediaEntry format
  const entries: MediaEntry[] = [
    ...(moviesData?.data?.map(convertServerMovieToMediaEntry) || []),
    ...(watchlistData?.data?.map(convertServerWatchlistToMediaEntry) || []),
    ...(favoritesData?.data?.map(convertServerFavoriteToMediaEntry) || []),
  ];

  const watchlist = entries.filter(
    (entry) => entry.status === WatchStatus.PLANNING || entry.status === WatchStatus.PAUSED,
  );

  const recentlyWatched = entries
    .filter((entry) => entry.dateWatched)
    .sort((a, b) => new Date(b.dateWatched!).getTime() - new Date(a.dateWatched!).getTime())
    .slice(0, 6);

  // Replace the stub functions with real backend mutations
  const addEntry = async (entry: MediaEntry) => {
    try {
      if (entry.type === 'movie') {
        await MovieService.addMovie({
          tmdbId: Number(entry.id),
          rating: entry.rating,
          notes: entry.notes,
          watchedAt: entry.dateWatched,
        });
      } else if (entry.type === 'tv') {
        // If you have a TV show add endpoint, call it here
        // await TvShowService.addTvShow(...)
      }
      if (entry.favorite) {
        await FavoriteService.addToFavorites({
          tmdbId: Number(entry.id),
          mediaType: entry.type,
          title: entry.title,
          posterPath: entry.poster,
        });
      }
      if (entry.review) {
        await ReviewService.createReview({
          content: entry.review,
          rating: entry.rating,
          tmdbId: Number(entry.id),
          mediaType: entry.type,
        });
      }
      // Optionally add to watchlist
      if (entry.status === WatchStatus.PLANNING) {
        await WatchlistService.addToWatchlist({
          tmdbId: Number(entry.id),
          mediaType: entry.type,
          title: entry.title,
          posterPath: entry.poster,
        });
      }
    } catch (error) {
      console.error('Failed to add entry:', error);
    }
  };

  const updateEntry = async (id: string, updatedEntry: Partial<MediaEntry>) => {
    try {
      await MovieService.updateMovie(id, updatedEntry);
      // If updating favorite status
      if (updatedEntry.favorite !== undefined) {
        if (updatedEntry.favorite) {
          await FavoriteService.addToFavorites({
            tmdbId: Number(id),
            mediaType: updatedEntry.type || 'movie',
            title: updatedEntry.title || '',
            posterPath: updatedEntry.poster,
          });
        } else {
          await FavoriteService.removeFromFavorites(id);
        }
      }
      // If updating review
      if (updatedEntry.review) {
        // You need the reviewId to update; this is a placeholder
        // await ReviewService.updateReview(reviewId, { content: updatedEntry.review });
      }
      // If updating watchlist status
      if (updatedEntry.status === WatchStatus.PLANNING) {
        await WatchlistService.addToWatchlist({
          tmdbId: Number(id),
          mediaType: updatedEntry.type || 'movie',
          title: updatedEntry.title || '',
          posterPath: updatedEntry.poster,
        });
      } else if (updatedEntry.status !== undefined) {
        await WatchlistService.removeFromWatchlist(id);
      }
    } catch (error) {
      console.error('Failed to update entry:', error);
    }
  };

  const removeEntry = async (id: string) => {
    try {
      await MovieService.deleteMovie(id);
      await FavoriteService.removeFromFavorites(id);
      // You need the reviewId to delete; this is a placeholder
      // await ReviewService.deleteReview(reviewId);
      await WatchlistService.removeFromWatchlist(id);
    } catch (error) {
      console.error('Failed to remove entry:', error);
    }
  };

  const isLoading = moviesLoading || watchlistLoading || favoritesLoading;
  const error = moviesError?.message || watchlistError?.message || favoritesError?.message || null;

  const value = {
    entries,
    watchlist,
    recentlyWatched,
    addEntry,
    updateEntry,
    removeEntry,
    isLoading,
    error,
  };

  return <EntryContext.Provider value={value}>{children}</EntryContext.Provider>;
};
