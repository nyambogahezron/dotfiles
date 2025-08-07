import MovieItemSkeleton from '@/components/LoadingSkeletons';
import MediaCard from '@/components/MediaCard';
import MediaSectionHeader from '@/components/MediaSectionHeader';
import SearchBar from '@/components/SearchBar';
import Colors from '@/constants/Colors';
import {
  fallbackProfileImage,
  fetchMovies,
  fetchTopTreadingMovies,
  fetchTreadingTV,
  fetchUpcomingTV,
  image500,
} from '@repo/services';
import { useFetch } from '@repo/services/usefetch';
import type { MovieOrTV } from '@repo/interfaces';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { useState } from 'react';
import { FlatList, ScrollView, StyleSheet, Text, View } from 'react-native';

export default function DiscoverScreen() {
  const [searchQuery, setSearchQuery] = useState('');

  const {
    data: movies,
    loading: moviesLoading,
    error: moviesError,
  } = useFetch(() => fetchMovies({ query: '' }));

  const { data: upcomingMovies, loading: upcomingMoviesLoading } = useFetch(() =>
    fetchTopTreadingMovies(),
  );

  const { data: treadingTv, loading: treadingTvLoading } = useFetch(() => fetchTreadingTV());

  const { data: upcomingTV, loading: upcomingTVLoading } = useFetch(() => fetchUpcomingTV());

  if (moviesError) {
    return (
      <View style={styles.errorContainer}>
        <Text style={styles.errorText}>Failed to load movies</Text>
        <Text style={styles.errorSubtext}>{moviesError.message}</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        <SearchBar
          value={searchQuery}
          onChangeText={setSearchQuery}
          placeholder="Search movies, TV shows..."
          onSubmit={() => {
            if (searchQuery.trim()) {
              router.push(`/search?q=${encodeURIComponent(searchQuery.trim())}`);
            }
          }}
          onPress={() => router.push('/search')}
        />

        <View style={styles.section}>
          <MediaSectionHeader
            title="Trending Movies"
            onPressSeeAll={() => router.push('/media/see-all/trending-movies')}
          />

          {moviesLoading ? (
            <MovieItemSkeleton />
          ) : (
            <FlatList
              horizontal
              showsHorizontalScrollIndicator={false}
              data={
                movies?.map((item: MovieOrTV) => ({
                  ...item,
                  title: item.title || item.name || 'Unknown Title',
                  posterUrl: image500(item.poster_path) || fallbackProfileImage,
                  type: 'movie' as const,
                  rating:
                    item.vote_average && item.vote_average > 0 ? item.vote_average : undefined,
                  year: item.release_date ? Number(item.release_date.slice(0, 4)) : 0,
                })) || []
              }
              keyExtractor={(item) => item.id.toString()}
              renderItem={({ item }) => <MediaCard media={item} type="movie" />}
              style={styles.list}
              contentContainerStyle={styles.listContent}
            />
          )}
        </View>

        <View style={styles.section}>
          <MediaSectionHeader
            title="Upcoming Movies"
            onPressSeeAll={() => router.push('/media/see-all/upcoming-movies')}
          />
          {upcomingMoviesLoading ? (
            <MovieItemSkeleton />
          ) : (
            <FlatList
              horizontal
              showsHorizontalScrollIndicator={false}
              data={
                upcomingMovies?.map((item: MovieOrTV) => ({
                  ...item,
                  title: item.title || item.name || 'Unknown Title',
                  posterUrl: image500(item.poster_path) || fallbackProfileImage,
                  type: 'movie' as const,
                  rating:
                    item.vote_average && item.vote_average > 0 ? item.vote_average : undefined,
                  year: item.release_date ? Number(item.release_date.slice(0, 4)) : 0,
                })) || []
              }
              keyExtractor={(item) => item.id.toString()}
              renderItem={({ item }) => <MediaCard media={item} type="movie" />}
              style={styles.list}
              contentContainerStyle={styles.listContent}
            />
          )}
        </View>

        <View style={styles.section}>
          <MediaSectionHeader
            title="Trending TV Series"
            onPressSeeAll={() => router.push('/media/see-all/trending-tv')}
            icon={<Ionicons name="trending-up" size={20} color={Colors.primary[500]} />}
          />

          {treadingTvLoading ? (
            <MovieItemSkeleton />
          ) : (
            <FlatList
              horizontal
              showsHorizontalScrollIndicator={false}
              data={
                treadingTv?.map((item: MovieOrTV) => ({
                  ...item,
                  title: item.title || item.name || 'Unknown Title',
                  posterUrl: image500(item.poster_path) || fallbackProfileImage,
                  type: 'tv' as const,
                  rating:
                    item.vote_average && item.vote_average > 0 ? item.vote_average : undefined,
                  year:
                    item.release_date || item.first_air_date
                      ? Number((item.release_date || item.first_air_date)!.slice(0, 4))
                      : 0,
                })) || []
              }
              keyExtractor={(item) => item.id.toString()}
              renderItem={({ item }) => <MediaCard media={item} type="tv" />}
              style={styles.list}
              contentContainerStyle={styles.listContent}
            />
          )}
        </View>

        <View style={styles.section}>
          <MediaSectionHeader
            title="Upcoming TV Series"
            onPressSeeAll={() => router.push('/media/see-all/upcoming-tv')}
            icon={<Ionicons name="trending-up" size={20} color={Colors.primary[500]} />}
          />

          {upcomingTVLoading ? (
            <MovieItemSkeleton />
          ) : upcomingTV && upcomingTV.length > 0 ? (
            <FlatList
              horizontal
              showsHorizontalScrollIndicator={false}
              data={
                upcomingTV?.map((item: MovieOrTV) => ({
                  ...item,
                  title: item.title || item.name || 'Unknown Title',
                  posterUrl: image500(item.poster_path) || fallbackProfileImage,
                  type: 'tv' as const,
                  rating:
                    item.vote_average && item.vote_average > 0 ? item.vote_average : undefined,
                  year:
                    item.release_date || item.first_air_date
                      ? Number((item.release_date || item.first_air_date)!.slice(0, 4))
                      : 0,
                })) || []
              }
              keyExtractor={(item) => item.id.toString()}
              renderItem={({ item }) => <MediaCard media={item} type="tv" />}
              style={styles.list}
              contentContainerStyle={styles.listContent}
            />
          ) : null}
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.neutral[950],
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    padding: 16,
    paddingTop: 45,
    paddingBottom: 32,
  },
  section: {
    marginBottom: 24,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  sectionTitle: {
    fontFamily: 'Inter-Medium',
    fontSize: 18,
    color: Colors.neutral[100],
    marginLeft: 8,
  },
  list: {
    marginLeft: -8,
  },
  listContent: {
    paddingLeft: 8,
    paddingRight: 16,
  },
  loader: {
    marginVertical: 32,
  },
  errorContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: Colors.neutral[950],
    padding: 24,
  },
  errorText: {
    fontFamily: 'Inter-Bold',
    fontSize: 20,
    color: Colors.neutral[100],
    marginBottom: 8,
  },
  errorSubtext: {
    fontFamily: 'Inter-Regular',
    fontSize: 16,
    color: Colors.neutral[400],
    textAlign: 'center',
  },
});
