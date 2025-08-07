'use client';

import React, { useState } from 'react';
import { TrendingUp, Calendar, Film, Tv, Search as SearchIcon } from 'lucide-react';
import MediaCard from '../../components/media/MediaCard';
import MediaSectionHeader from '../../components/discovery/MediaSectionHeader';
import { MediaEntry, WatchStatus } from '../../types';
import {
  fetchMovies,
  fetchTopTreadingMovies,
  fetchTreadingTV,
  fetchUpcomingTV,
  useFetch,
  image500,
} from '@repo/services';

const fallbackProfileImage =
  'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png';
import type { MovieOrTV } from '@repo/interfaces';
import { useRouter } from 'next/navigation';

const Discovery: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const router = useRouter();

  // Fetch movie data using shared services
  const {
    data: movies,
    loading: moviesLoading,
    error: moviesError,
  } = useFetch(() => fetchMovies({ query: '' }));

  const { data: upcomingMovies, loading: upcomingMoviesLoading } = useFetch(() =>
    fetchTopTreadingMovies(),
  );

  const { data: trendingTv, loading: trendingTvLoading } = useFetch(() => fetchTreadingTV());

  const { data: upcomingTV, loading: upcomingTVLoading } = useFetch(() => fetchUpcomingTV());

  const handleSearch = () => {
    if (searchQuery.trim()) {
      router.push(`/search?q=${encodeURIComponent(searchQuery.trim())}`);
    }
  };

  const transformMovieData = (items: MovieOrTV[]): MediaEntry[] => {
    return (
      items?.map((item: MovieOrTV) => ({
        id: item.id.toString(),
        title: item.title || item.name || 'Unknown Title',
        type: item.title ? 'movie' : 'tv',
        poster: image500(item.poster_path) || fallbackProfileImage,
        backdrop: image500(item.backdrop_path) || fallbackProfileImage,
        rating: item.vote_average ? Math.round(item.vote_average * 10) / 20 : 0, // Convert to 5-star scale
        status: WatchStatus.PLANNING,
        year:
          item.release_date || item.first_air_date
            ? new Date(item.release_date || item.first_air_date || '').getFullYear()
            : undefined,
        tmdbId: item.id,
        overview: item.overview,
        rewatches: 0,
        private: false,
        favorite: false,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      })) || []
    );
  };

  if (moviesError) {
    return (
      <div className="container-custom py-16">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-white">Failed to load movies</h2>
          <p className="text-gray-400 mt-2">{moviesError.message}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container-custom py-8">
      <div className="max-width-6xl mx-auto">
        <h1 className="text-3xl font-bold text-white mb-6">Discover Movies & TV Shows</h1>

        {/* Search Bar */}
        <div className="mb-8">
          <form
            onSubmit={(e) => {
              e.preventDefault();
              handleSearch();
            }}
            className="w-full"
          >
            <div className="relative">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onClick={() => router.push('/search')}
                placeholder="Search movies, TV shows..."
                className="w-full bg-gray-800 border border-gray-600 rounded-lg pl-10 pr-4 py-3 text-white placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200"
              />
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <SearchIcon className="h-5 w-5 text-gray-400" />
              </div>
            </div>
          </form>
        </div>

        <div className="space-y-8">
          {/* Trending Movies */}
          <section>
            <MediaSectionHeader
              title="Trending Movies"
              onPressSeeAll={() => router.push('/see-all/trending-movies')}
              icon={<Film className="w-5 h-5 text-blue-400" />}
            />

            {moviesLoading ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {Array.from({ length: 6 }).map((_, index) => (
                  <div key={index} className="animate-pulse">
                    <div className="bg-gray-700 aspect-[2/3] rounded-lg mb-2"></div>
                    <div className="bg-gray-700 h-4 rounded mb-1"></div>
                    <div className="bg-gray-700 h-3 rounded w-2/3"></div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {transformMovieData(movies?.slice(0, 6) || []).map((movie) => (
                  <MediaCard key={movie.id} media={movie} />
                ))}
              </div>
            )}
          </section>

          {/* Upcoming Movies */}
          <section>
            <MediaSectionHeader
              title="Upcoming Movies"
              onPressSeeAll={() => router.push('/see-all/upcoming-movies')}
              icon={<Calendar className="w-5 h-5 text-green-400" />}
            />

            {upcomingMoviesLoading ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {Array.from({ length: 6 }).map((_, index) => (
                  <div key={index} className="animate-pulse">
                    <div className="bg-gray-700 aspect-[2/3] rounded-lg mb-2"></div>
                    <div className="bg-gray-700 h-4 rounded mb-1"></div>
                    <div className="bg-gray-700 h-3 rounded w-2/3"></div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {transformMovieData(upcomingMovies?.slice(0, 6) || []).map((movie) => (
                  <MediaCard key={movie.id} media={movie} />
                ))}
              </div>
            )}
          </section>

          {/* Trending TV Shows */}
          <section>
            <MediaSectionHeader
              title="Trending TV Shows"
              onPressSeeAll={() => router.push('/see-all/trending-tv')}
              icon={<TrendingUp className="w-5 h-5 text-purple-400" />}
            />

            {trendingTvLoading ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {Array.from({ length: 6 }).map((_, index) => (
                  <div key={index} className="animate-pulse">
                    <div className="bg-gray-700 aspect-[2/3] rounded-lg mb-2"></div>
                    <div className="bg-gray-700 h-4 rounded mb-1"></div>
                    <div className="bg-gray-700 h-3 rounded w-2/3"></div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {transformMovieData(trendingTv?.slice(0, 6) || []).map((show) => (
                  <MediaCard key={show.id} media={show} />
                ))}
              </div>
            )}
          </section>

          {/* Upcoming TV Shows */}
          <section>
            <MediaSectionHeader
              title="Upcoming TV Series"
              onPressSeeAll={() => router.push('/see-all/upcoming-tv')}
              icon={<Tv className="w-5 h-5 text-yellow-400" />}
            />

            {upcomingTVLoading ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {Array.from({ length: 6 }).map((_, index) => (
                  <div key={index} className="animate-pulse">
                    <div className="bg-gray-700 aspect-[2/3] rounded-lg mb-2"></div>
                    <div className="bg-gray-700 h-4 rounded mb-1"></div>
                    <div className="bg-gray-700 h-3 rounded w-2/3"></div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {transformMovieData(upcomingTV?.slice(0, 6) || []).map((show) => (
                  <MediaCard key={show.id} media={show} />
                ))}
              </div>
            )}
          </section>
        </div>
      </div>
    </div>
  );
};

export default Discovery;
