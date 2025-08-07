import {
  useWatchlist as useWatchlistQuery,
  useFavorites as useFavoritesQuery,
} from '@repo/services';

export const useWatchlist = () => {
  return useWatchlistQuery();
};

export const useFavorites = () => {
  return useFavoritesQuery();
};
