import Colors from '@/constants/Colors';
import { useWatchlist, useUserMovies } from '@repo/services';
import { Ionicons } from '@expo/vector-icons';
import { useMemo } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';

type LibraryItem = {
  id: number;
  title?: string;
  name?: string;
  poster_path?: string;
  backdrop_path?: string;
  vote_average?: number;
  release_date?: string;
  first_air_date?: string;
  overview?: string;
  type: 'movie' | 'tv';
  year?: number;
  genres?: string[];
  rating?: number;
};

type MonthlyStats = {
  month: string;
  count: number;
  hours: number;
};

type GenreStats = {
  name: string;
  count: number;
  color: string;
};

const GENRE_COLORS = [
  Colors.primary[500],
  Colors.accent[500],
  Colors.success[500],
  Colors.warning[500],
  Colors.error[500],
];

export default function StatsScreen() {
  const { library } = useLibrary();

  // Calculate total watch time (assuming average movie is 2h and TV episode is 45min)
  const totalWatchTime = useMemo(() => {
    return library.reduce((total: number, item: LibraryItem) => {
      const duration = item.type === 'movie' ? 120 : 45; // minutes
      return total + duration;
    }, 0);
  }, [library]);

  // Calculate monthly stats
  const monthlyStats = useMemo(() => {
    const months: Record<string, MonthlyStats> = {};
    const now = new Date();

    // Initialize last 6 months
    for (let i = 0; i < 6; i++) {
      const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
      const monthKey = date.toLocaleString('default', {
        month: 'short',
        year: 'numeric',
      });
      months[monthKey] = { month: monthKey, count: 0, hours: 0 };
    }

    // Fill in actual data
    library.forEach((item: LibraryItem) => {
      const date = new Date(item.year || 2020, 0, 1); // Using year for now, replace with actual watch date
      const monthKey = date.toLocaleString('default', {
        month: 'short',
        year: 'numeric',
      });
      if (months[monthKey]) {
        months[monthKey].count++;
        months[monthKey].hours += item.type === 'movie' ? 2 : 0.75; // Approximate hours
      }
    });

    return Object.values(months).reverse();
  }, [library]);

  // Calculate genre stats
  const genreStats = useMemo(() => {
    const genres: Record<string, number> = {};

    library.forEach((item: LibraryItem) => {
      item.genres?.forEach((genre: string) => {
        genres[genre] = (genres[genre] || 0) + 1;
        console.log(genres);
      });
    });

    return Object.entries(genres)
      .map(([name, count], index) => ({
        name,
        count,
        color: GENRE_COLORS[index % GENRE_COLORS.length],
      }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);
  }, [library]);

  // Calculate type distribution
  const typeStats = useMemo(() => {
    const movies = library.filter((item: LibraryItem) => item.type === 'movie').length;
    const shows = library.filter((item: LibraryItem) => item.type === 'tv').length;
    return { movies, shows };
  }, [library]);

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Overview Stats */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="bar-chart" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Overview</Text>
        </View>
        <View style={styles.statsGrid}>
          <View style={styles.statCard}>
            <Ionicons name="film" size={20} color={Colors.primary[500]} />
            <Text style={styles.statValue}>{library.length}</Text>
            <Text style={styles.statLabel}>Total Watched</Text>
          </View>
          <View style={styles.statCard}>
            <Ionicons name="time" size={20} color={Colors.primary[500]} />
            <Text style={styles.statValue}>{Math.round(totalWatchTime / 60)}h</Text>
            <Text style={styles.statLabel}>Watch Time</Text>
          </View>
          <View style={styles.statCard}>
            <Ionicons name="star" size={20} color={Colors.primary[500]} />
            <Text style={styles.statValue}>
              {(
                library.reduce((acc: number, curr: LibraryItem) => acc + (curr.rating || 0), 0) /
                  library.length || 0
              ).toFixed(1)}
            </Text>
            <Text style={styles.statLabel}>Avg. Rating</Text>
          </View>
          <View style={styles.statCard}>
            <Ionicons name="tv" size={20} color={Colors.primary[500]} />
            <Text style={styles.statValue}>{library.length}</Text>
            <Text style={styles.statLabel}>In Progress</Text>
          </View>
        </View>
      </View>

      {/* Monthly Activity */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="calendar" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Monthly Activity</Text>
        </View>
        <View style={styles.monthlyContainer}>
          {monthlyStats.map((stat) => (
            <View key={stat.month} style={styles.monthlyItem}>
              <Text style={styles.monthlyLabel}>{stat.month}</Text>
              <View style={styles.monthlyBar}>
                <View
                  style={[
                    styles.monthlyBarFill,
                    {
                      width: `${
                        (stat.count / Math.max(...monthlyStats.map((s) => s.count))) * 100
                      }%`,
                      backgroundColor: Colors.primary[500],
                    },
                  ]}
                />
              </View>
              <Text style={styles.monthlyValue}>{stat.count} titles</Text>
              <Text style={styles.monthlyHours}>{Math.round(stat.hours)}h watched</Text>
            </View>
          ))}
        </View>
      </View>

      {/* Genre Distribution */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="film" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Top Genres</Text>
        </View>
        <View style={styles.genresContainer}>
          {genreStats.map((genre) => (
            <View key={genre.name} style={styles.genreItem}>
              <View style={styles.genreHeader}>
                <View style={[styles.genreColor, { backgroundColor: genre.color }]} />
                <Text style={styles.genreName}>{genre.name}</Text>
              </View>
              <View style={styles.genreBar}>
                <View
                  style={[
                    styles.genreBarFill,
                    {
                      width: `${(genre.count / genreStats[0].count) * 100}%`,
                      backgroundColor: genre.color,
                    },
                  ]}
                />
              </View>
              <Text style={styles.genreCount}>{genre.count} titles</Text>
            </View>
          ))}
        </View>
      </View>

      {/* Content Type Distribution */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="tv" size={24} color={Colors.primary[500]} />
          <Text style={styles.sectionTitle}>Content Type</Text>
        </View>
        <View style={styles.typeContainer}>
          <View style={styles.typeItem}>
            <View style={styles.typeHeader}>
              <Ionicons name="film" size={20} color={Colors.primary[500]} />
              <Text style={styles.typeName}>Movies</Text>
            </View>
            <Text style={styles.typeValue}>{typeStats.movies}</Text>
            <Text style={styles.typePercentage}>
              {Math.round((typeStats.movies / library.length) * 100)}%
            </Text>
          </View>
          <View style={styles.typeItem}>
            <View style={styles.typeHeader}>
              <Ionicons name="tv" size={20} color={Colors.accent[500]} />
              <Text style={styles.typeName}>TV Shows</Text>
            </View>
            <Text style={styles.typeValue}>{typeStats.shows}</Text>
            <Text style={styles.typePercentage}>
              {Math.round((typeStats.shows / library.length) * 100)}%
            </Text>
          </View>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.neutral[950],
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
  },
  statsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  statCard: {
    width: '48%',
    backgroundColor: Colors.neutral[900],
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    alignItems: 'center',
  },
  statValue: {
    color: Colors.primary[500],
    fontSize: 24,
    fontFamily: 'Inter-Bold',
    marginTop: 8,
    marginBottom: 4,
  },
  statLabel: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  monthlyContainer: {
    backgroundColor: Colors.neutral[900],
    borderRadius: 12,
    padding: 16,
  },
  monthlyItem: {
    marginBottom: 16,
  },
  monthlyLabel: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
    marginBottom: 8,
  },
  monthlyBar: {
    height: 8,
    backgroundColor: Colors.neutral[800],
    borderRadius: 4,
    marginBottom: 4,
  },
  monthlyBarFill: {
    height: '100%',
    borderRadius: 4,
  },
  monthlyValue: {
    color: Colors.neutral[50],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  monthlyHours: {
    color: Colors.neutral[400],
    fontSize: 12,
    fontFamily: 'Inter-Regular',
  },
  genresContainer: {
    backgroundColor: Colors.neutral[900],
    borderRadius: 12,
    padding: 16,
  },
  genreItem: {
    marginBottom: 16,
  },
  genreHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  genreColor: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: 8,
  },
  genreName: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  genreBar: {
    height: 8,
    backgroundColor: Colors.neutral[800],
    borderRadius: 4,
    marginBottom: 4,
  },
  genreBarFill: {
    height: '100%',
    borderRadius: 4,
  },
  genreCount: {
    color: Colors.neutral[50],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
  },
  typeContainer: {
    backgroundColor: Colors.neutral[900],
    borderRadius: 12,
    padding: 16,
  },
  typeItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  typeHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  typeName: {
    color: Colors.neutral[50],
    fontSize: 16,
    fontFamily: 'Inter-Medium',
    marginLeft: 8,
  },
  typeValue: {
    color: Colors.primary[500],
    fontSize: 16,
    fontFamily: 'Inter-Bold',
    marginHorizontal: 16,
  },
  typePercentage: {
    color: Colors.neutral[400],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
    width: 48,
    textAlign: 'right',
  },
});
