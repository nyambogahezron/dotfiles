import MediaCard from '@/components/MediaCard';
import Colors from '@/constants/Colors';
import { useUserMovies } from '@repo/services/queries';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import Feather from '@expo/vector-icons/Feather';
import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View, ActivityIndicator } from 'react-native';

// Styled wrapper for MediaCard

const StyledMediaCard = ({ media, type }: { media: any; type: 'movie' | 'tv' }) => (
  <View style={styles.mediaCard}>
    <MediaCard media={media} type={type} />
  </View>
);

export default function DashboardScreen() {
  const router = useRouter();
  const {
    data: watchedContent = [],
    isLoading: loading,
    isError: error,
  } = useUserMovies({ sortBy: 'recent', filterBy: 'all' });
  // You may need to fetch analytics, watchlist, etc. with other hooks from @repo/services/queries if needed

  // Get recently watched movies (last 5)
  const recentMovies = watchedContent.slice(0, 5);
  // Placeholder values for stats
  const totalWatched = watchedContent.length;
  const averageRating =
    watchedContent.length > 0
      ? watchedContent.reduce((sum: any, m: any) => sum + (m.rating || 0), 0) /
        watchedContent.length
      : 0;
  const watchlistCount = 0; // TODO: Replace with real value from watchlist query
  const thisMonth = 12; // Placeholder, replace with analytics data if available

  if (loading) {
    return (
      <View style={[styles.container, styles.centered]}>
        <ActivityIndicator size="large" color={Colors.primary[500]} />
        <Text style={styles.loadingText}>Loading your stats...</Text>
      </View>
    );
  }

  if (error) {
    return (
      <View style={[styles.container, styles.centered]}>
        <Text style={styles.errorText}>Unable to load your data</Text>
        <Text style={styles.errorSubtext}>Please check your connection and try again</Text>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Stats Section */}
      <View style={styles.statsContainer}>
        <View style={styles.statsHeader}>
          <Ionicons name="bar-chart" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Your Stats</Text>
        </View>
        <View style={styles.statsGrid}>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{totalWatched}</Text>
            <Text style={styles.statLabel}>Total Watched</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{averageRating.toFixed(1)}</Text>
            <Text style={styles.statLabel}>Avg. Rating</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{thisMonth}</Text>
            <Text style={styles.statLabel}>This Month</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{watchlistCount}</Text>
            <Text style={styles.statLabel}>Watchlist</Text>
          </View>
        </View>
      </View>

      {/* Recently Watched Section */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="time" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Recently Watched</Text>
          <Pressable onPress={() => router.push('/(tabs)/library')}>
            <Text style={styles.seeAll}>See All</Text>
          </Pressable>
        </View>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.mediaScroll}>
          {recentMovies.map((movie: any) => (
            <StyledMediaCard key={movie.id} media={movie} type={movie.type} />
          ))}
        </ScrollView>
      </View>

      {/* Diary Section */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="book" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Latest Diary Entries</Text>
          <Pressable onPress={() => router.push('/(tabs)/library')}>
            <Text style={styles.seeAll}>See All</Text>
          </Pressable>
        </View>
        <View style={styles.diaryContainer}>
          <Text style={styles.comingSoon}>Your diary entries will appear here</Text>
        </View>
      </View>

      {/* Watchlist Section */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="add-circle" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Watchlist</Text>
          <Pressable onPress={() => router.push('/(tabs)/library')}>
            <Text style={styles.seeAll}>See All</Text>
          </Pressable>
        </View>
        {/* TODO: Replace with real watchlist data */}
        {/* <ScrollView
		  horizontal
		  showsHorizontalScrollIndicator={false}
		  style={styles.mediaScroll}
		>
		  {watchlistContent.slice(0, 5).map((movie) => (
			<StyledMediaCard key={movie.id} media={movie} type={movie.type} />
		  ))}
		</ScrollView> */}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingVertical: 35,
    backgroundColor: Colors.neutral[950],
  },
  statsContainer: {
    padding: 16,
    backgroundColor: Colors.neutral[900],
    borderRadius: 12,
    margin: 16,
  },
  statsHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  statsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  statCard: {
    width: '48%',
    backgroundColor: Colors.neutral[800],
    padding: 16,
    borderRadius: 8,
    marginBottom: 12,
    alignItems: 'center',
  },
  statValue: {
    color: Colors.primary[500],
    fontSize: 24,
    fontFamily: 'Inter-Bold',
    marginBottom: 4,
  },
  statLabel: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  section: {
    marginBottom: 24,
    paddingHorizontal: 16,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  sectionTitle: {
    color: Colors.neutral[50],
    fontSize: 20,
    fontFamily: 'Inter-Bold',
    marginLeft: 8,
    flex: 1,
  },
  seeAll: {
    color: Colors.primary[500],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  mediaScroll: {
    marginHorizontal: -16,
    paddingHorizontal: 16,
  },
  mediaCard: {
    marginRight: 12,
    width: 140,
  },
  diaryContainer: {
    backgroundColor: Colors.neutral[900],
    borderRadius: 12,
    padding: 16,
    minHeight: 120,
    justifyContent: 'center',
    alignItems: 'center',
  },
  comingSoon: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  centered: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    color: Colors.neutral[400],
    fontSize: 16,
    fontFamily: 'Inter-Medium',
    marginTop: 12,
  },
  errorText: {
    color: Colors.error[500],
    fontSize: 18,
    fontFamily: 'Inter-Bold',
    textAlign: 'center',
    marginBottom: 8,
  },
  errorSubtext: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
    textAlign: 'center',
  },
});
