import React from 'react';
import { BarChart3, Clock, Film, Tv, Star } from 'lucide-react';
import { useUserAnalytics } from '@repo/services';

const StatsOverview: React.FC = () => {
  const { data: analytics, isLoading, error } = useUserAnalytics();

  if (isLoading) {
    return (
      <div className="bg-gray-800 rounded-lg p-6">
        <div className="animate-pulse">
          <div className="h-6 bg-gray-700 rounded mb-4"></div>
          <div className="grid grid-cols-2 gap-4">
            <div className="h-16 bg-gray-700 rounded"></div>
            <div className="h-16 bg-gray-700 rounded"></div>
            <div className="h-16 bg-gray-700 rounded"></div>
            <div className="h-16 bg-gray-700 rounded"></div>
          </div>
        </div>
      </div>
    );
  }

  if (error || !analytics) {
    return (
      <div className="bg-gray-800 rounded-lg p-6">
        <div className="text-center text-gray-400">
          <p>Unable to load statistics</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-800 rounded-lg p-6">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-semibold flex items-center">
          <BarChart3 className="mr-2 h-5 w-5 text-purple-400" />
          Your Stats
        </h2>
      </div>

      <div className="grid grid-cols-2 gap-4 mb-6">
        <div className="bg-gray-700 p-4 rounded-lg">
          <div className="flex items-center text-gray-400 mb-1">
            <Clock className="h-4 w-4 mr-1" />
            <span className="text-sm">Total Watched</span>
          </div>
          <p className="text-xl font-semibold">{analytics.totalWatched} items</p>
        </div>

        <div className="bg-gray-700 p-4 rounded-lg">
          <div className="flex items-center text-gray-400 mb-1">
            <Star className="h-4 w-4 mr-1 text-yellow-400" />
            <span className="text-sm">Average Rating</span>
          </div>
          <p className="text-xl font-semibold">{analytics.averageRating.toFixed(1)}/5</p>
        </div>

        <div className="bg-gray-700 p-4 rounded-lg">
          <div className="flex items-center text-gray-400 mb-1">
            <Film className="h-4 w-4 mr-1" />
            <span className="text-sm">Movies Watched</span>
          </div>
          <p className="text-xl font-semibold">{analytics.totalMovies}</p>
        </div>

        <div className="bg-gray-700 p-4 rounded-lg">
          <div className="flex items-center text-gray-400 mb-1">
            <Tv className="h-4 w-4 mr-1" />
            <span className="text-sm">TV Shows Watched</span>
          </div>
          <p className="text-xl font-semibold">{analytics.totalTVShows}</p>
        </div>
      </div>

      {analytics.favoriteGenres.length > 0 && (
        <div>
          <h3 className="text-lg font-medium text-gray-200 mb-3">Top Genres</h3>
          <div className="space-y-2">
            {analytics.favoriteGenres.slice(0, 3).map((genre) => (
              <div key={genre.genre} className="flex justify-between items-center">
                <span className="text-gray-400">{genre.genre}</span>
                <span className="text-white font-medium">{genre.count}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default StatsOverview;
