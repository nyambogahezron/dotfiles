import Colors from '@/constants/Colors';
import { useTrendingMovies, useTrendingTVShows, useWatchlist } from '@repo/services';
// import { useDownloads } from '@repo/context';
import VideoSection from '@/components/VideoSection';
import ReviewsSection from '@/components/ReviewsSection';
import StreamingProviders from '@/components/StreamingProviders';
import QualitySelectionModal, { QualityOption } from '@/components/QualitySelectionModal';
import MediaDetailsSkeleton from '@/components/LoadingSkeletons/MediaDetailsSkeleton';
import {
  fetchMovieDetails,
  fetchTVDetails,
  fetchMovieCredits,
  fetchTVCredits,
  fetchRelatedMovies,
  fetchRelatedTV,
  fetchMovieVideos,
  fetchTVVideos,
  fetchMovieReviews,
  fetchTVReviews,
  fetchMovieWatchProviders,
  fetchTVWatchProviders,
  image500,
  image185,
} from '@repo/services';
import type { Cast, Credits, Video, Review, WatchProvider, MovieOrTV } from '@repo/interfaces';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { useRef, useState, useEffect } from 'react';
import {
  Animated,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  Image,
  FlatList,
} from 'react-native';

const HEADER_HEIGHT = 400;
const HEADER_MIN_HEIGHT = Platform.OS === 'ios' ? 90 : 70;

export default function MediaDetailsScreen() {
  const { id, type: queryType } = useLocalSearchParams();
  const router = useRouter();
  const scrollY = useRef(new Animated.Value(0)).current;
  const [isFavorite, setIsFavorite] = useState(false);
  const [loading, setLoading] = useState(true);
  const [mediaDetails, setMediaDetails] = useState<any>(null);
  const [cast, setCast] = useState<Cast[]>([]);
  const [relatedContent, setRelatedContent] = useState<MovieOrTV[]>([]);
  const [videos, setVideos] = useState<Video[]>([]);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [watchProviders, setWatchProviders] = useState<WatchProvider[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [showQualityModal, setShowQualityModal] = useState(false);

  // Get media data from trending content and watchlist
  const { data: trendingMoviesData } = useTrendingMovies();
  const { data: trendingTVData } = useTrendingTVShows();
  const { data: watchlistData } = useWatchlist();

  // Transform data to match expected format
  const trendingMovies = trendingMoviesData?.map((item: any) => ({
    id: item.id?.toString() || '0',
    title: item.title || 'Unknown',
    posterUrl: item.poster_path || 'https://via.placeholder.com/150',
    type: 'movie',
    year: item.release_date ? new Date(item.release_date).getFullYear() : 2024,
    rating: item.vote_average || 0,
  })) || [];

  const trendingShows = trendingTVData?.map((item: any) => ({
    id: item.id?.toString() || '0',
    title: item.name || 'Unknown',
    posterUrl: item.poster_path || 'https://via.placeholder.com/150',
    type: 'tv',
    year: item.first_air_date ? new Date(item.first_air_date).getFullYear() : 2024,
    rating: item.vote_average || 0,
  })) || [];

  const watchlistContent = watchlistData?.map((item: any) => ({
    id: item.tmdbId,
    title: item.title,
    posterUrl: item.posterPath,
    type: item.mediaType,
    year: new Date(item.createdAt).getFullYear(),
    genres: item.genres || [],
    rating: item.rating,
  })) || [];
  const { addDownload, isDownloading } = useDownloads();

  // Find the media item from all sources
  const media = [...trendingMovies, ...trendingShows, ...watchlistContent].find(
    (item) => item.id.toString() === id,
  );

  useEffect(() => {
    if (media || id) {
      fetchMediaDetails();
    }
  }, [id, media, queryType]);

  const fetchMediaDetails = async () => {
    try {
      setLoading(true);
      setError(null);

      const mediaId = media?.id?.toString() || id?.toString() || '';
      let mediaType = media?.type || (queryType as string) || 'movie';

      if (!media?.type) {
        try {
          // Try fetching as movie first
          const movieDetails = await fetchMovieDetails(mediaId);
          mediaType = 'movie';
          setMediaDetails(movieDetails);
        } catch (movieError) {
          try {
            // If movie fails, try as TV show
            const tvDetails = await fetchTVDetails(mediaId);
            mediaType = 'tv';
            setMediaDetails(tvDetails);
          } catch (tvError) {
            throw new Error('Failed to fetch media details');
          }
        }
      } else {
        // We know the media type, fetch accordingly
        let details;
        if (mediaType === 'tv') {
          details = await fetchTVDetails(mediaId);
        } else {
          details = await fetchMovieDetails(mediaId);
        }
        setMediaDetails(details);
      }

      // Fetch cast
      let castData;
      if (mediaType === 'tv') {
        castData = await fetchTVCredits(mediaId);
      } else {
        castData = await fetchMovieCredits(mediaId);
      }

      // Fetch related content
      let relatedData;
      if (mediaType === 'tv') {
        relatedData = await fetchRelatedTV(mediaId);
      } else {
        relatedData = await fetchRelatedMovies(mediaId);
      }

      // Fetch videos
      let videoData;
      if (mediaType === 'tv') {
        videoData = await fetchTVVideos(mediaId);
      } else {
        videoData = await fetchMovieVideos(mediaId);
      }

      // Fetch reviews
      let reviewData;
      if (mediaType === 'tv') {
        reviewData = await fetchTVReviews(mediaId);
      } else {
        reviewData = await fetchMovieReviews(mediaId);
      }

      // Fetch watch providers
      let watchProvidersData;
      if (mediaType === 'tv') {
        watchProvidersData = await fetchTVWatchProviders(mediaId);
      } else {
        watchProvidersData = await fetchMovieWatchProviders(mediaId);
      }

      setCast(castData.slice(0, 10)); // Limit to first 10 cast members
      setRelatedContent(relatedData.slice(0, 6)); // Limit to first 6 related items
      setVideos(videoData);
      setReviews(reviewData);
      setWatchProviders(watchProvidersData);
    } catch (err) {
      console.error('Error fetching media details:', err);
      setError('Failed to load media details');
    } finally {
      setLoading(false);
    }
  };

  const handleDownload = () => {
    setShowQualityModal(true);
  };

  const handleQualitySelected = (quality: QualityOption) => {
    const displayData = mediaDetails || media;
    if (!displayData) return;

    const mediaType = displayData.name ? 'tv' : 'movie';
    const mediaId = displayData.id?.toString() || id?.toString() || '';

    addDownload({
      mediaId,
      mediaType,
      title: displayData.title || displayData.name,
      poster: displayData.poster_path,
      fileSize: quality.fileSize,
      quality: quality.label,
      estimatedTime: '~5 min', // Default estimate
    });

    router.push('/(tabs)/downloads');
  };

  if (!media && !id) {
    return (
      <View style={styles.errorContainer}>
        <Text style={styles.errorText}>Media not found</Text>
      </View>
    );
  }

  if (loading) {
    return <MediaDetailsSkeleton />;
  }

  if (error) {
    return (
      <View style={styles.errorContainer}>
        <Text style={styles.errorText}>{error}</Text>
        <TouchableOpacity style={styles.retryButton} onPress={fetchMediaDetails}>
          <Text style={styles.retryButtonText}>Retry</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const displayData = mediaDetails || media;

  // Animation values
  const headerHeight = scrollY.interpolate({
    inputRange: [0, HEADER_HEIGHT - HEADER_MIN_HEIGHT],
    outputRange: [HEADER_HEIGHT, HEADER_MIN_HEIGHT],
    extrapolate: 'clamp',
  });

  const imageOpacity = scrollY.interpolate({
    inputRange: [0, HEADER_HEIGHT - HEADER_MIN_HEIGHT],
    outputRange: [1, 0.3],
    extrapolate: 'clamp',
  });

  const headerTitleOpacity = scrollY.interpolate({
    inputRange: [0, HEADER_HEIGHT - HEADER_MIN_HEIGHT],
    outputRange: [0, 1],
    extrapolate: 'clamp',
  });

  const favoriteButtonScale = scrollY.interpolate({
    inputRange: [0, HEADER_HEIGHT - HEADER_MIN_HEIGHT],
    outputRange: [1, 0.8],
    extrapolate: 'clamp',
  });

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.header, { height: headerHeight }]}>
        <Animated.Image
          source={{
            uri: displayData.backdrop_path
              ? image500(displayData.backdrop_path)
              : displayData.posterUrl || image500(displayData.poster_path),
          }}
          style={[styles.headerImage, { opacity: imageOpacity }]}
          resizeMode="cover"
        />

        {/* Header content */}
        <View style={styles.headerContent}>
          <Animated.View style={[styles.headerTitleContainer, { opacity: headerTitleOpacity }]}>
            <Text style={styles.headerTitle} numberOfLines={1}>
              {displayData.title || displayData.name}
            </Text>
          </Animated.View>

          <View style={styles.headerButtons}>
            <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
              <Ionicons name="chevron-back" size={24} color={Colors.neutral[100]} />
            </TouchableOpacity>

            <View style={styles.rightButtons}>
              <Animated.View style={{ transform: [{ scale: favoriteButtonScale }] }}>
                <TouchableOpacity
                  style={[
                    styles.actionButton,
                    !isDownloading(media?.id?.toString() || id?.toString() || '') &&
                      styles.downloadButton,
                  ]}
                  onPress={handleDownload}
                  disabled={isDownloading(media?.id?.toString() || id?.toString() || '')}
                >
                  <Ionicons
                    name="download"
                    size={20}
                    color={
                      isDownloading(media?.id?.toString() || id?.toString() || '')
                        ? Colors.neutral[400]
                        : Colors.neutral[100]
                    }
                  />
                </TouchableOpacity>
              </Animated.View>

              <Animated.View style={{ transform: [{ scale: favoriteButtonScale }] }}>
                <TouchableOpacity
                  style={[styles.actionButton, isFavorite && styles.favoriteButtonActive]}
                  onPress={() => setIsFavorite(!isFavorite)}
                >
                  <Ionicons
                    name="heart"
                    size={20}
                    color={isFavorite ? Colors.neutral[100] : Colors.neutral[100]}
                  />
                </TouchableOpacity>
              </Animated.View>
            </View>
          </View>
        </View>
      </Animated.View>

      <Animated.ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
        onScroll={Animated.event([{ nativeEvent: { contentOffset: { y: scrollY } } }], {
          useNativeDriver: false,
        })}
        scrollEventThrottle={16}
      >
        <View style={styles.content}>
          {/* Title and Basic Info */}
          <Text style={styles.title}>{displayData.title || displayData.name}</Text>

          <View style={styles.infoRow}>
            {(displayData.release_date || displayData.first_air_date) && (
              <View style={styles.infoItem}>
                <Ionicons name="calendar" size={16} color={Colors.neutral[400]} />
                <Text style={styles.infoText}>
                  {new Date(displayData.release_date || displayData.first_air_date).getFullYear()}
                </Text>
              </View>
            )}

            {displayData.runtime && (
              <View style={styles.infoItem}>
                <Ionicons name="time" size={16} color={Colors.neutral[400]} />
                <Text style={styles.infoText}>{displayData.runtime} min</Text>
              </View>
            )}

            {displayData.vote_average && (
              <View style={styles.infoItem}>
                <Ionicons name="star" size={16} color={Colors.warning[400]} />
                <Text style={styles.infoText}>{displayData.vote_average.toFixed(1)}</Text>
              </View>
            )}
          </View>

          {/* Genres */}
          {displayData.genres && displayData.genres.length > 0 && (
            <View style={styles.genresContainer}>
              {displayData.genres.map((genre: any) => (
                <View key={genre.id} style={styles.genreChip}>
                  <Text style={styles.genreText}>{genre.name}</Text>
                </View>
              ))}
            </View>
          )}

          {/* Overview */}
          {displayData.overview && (
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Overview</Text>
              <Text style={styles.overview}>{displayData.overview}</Text>
            </View>
          )}

          {/* Streaming Providers */}
          {Object.keys(watchProviders).length > 0 && (
            <StreamingProviders
              watchProviders={watchProviders}
              mediaTitle={displayData.title || displayData.name}
              mediaId={displayData.id?.toString() || id?.toString() || ''}
              mediaType={displayData.name ? 'tv' : 'movie'}
            />
          )}

          {/* Videos */}
          {videos.length > 0 && <VideoSection videos={videos} title="Videos & Trailers" />}

          {/* Cast */}
          {cast.length > 0 && (
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Cast</Text>
              <FlatList
                data={cast}
                horizontal
                showsHorizontalScrollIndicator={false}
                keyExtractor={(item) => item.id.toString()}
                renderItem={({ item }) => (
                  <TouchableOpacity
                    style={styles.castCard}
                    onPress={() => router.push(`/cast/${item.id}`)}
                    activeOpacity={0.8}
                  >
                    <Image
                      source={{
                        uri: item.profile_path
                          ? image185(item.profile_path)
                          : 'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png',
                      }}
                      style={styles.castImage}
                    />
                    <Text style={styles.castName} numberOfLines={2}>
                      {item.name}
                    </Text>
                    <Text style={styles.castCharacter} numberOfLines={2}>
                      {item.name}
                    </Text>
                  </TouchableOpacity>
                )}
                contentContainerStyle={styles.castList}
              />
            </View>
          )}

          {/* Related Content */}
          {relatedContent.length > 0 && (
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>More Like This</Text>
              <FlatList
                data={relatedContent}
                horizontal
                showsHorizontalScrollIndicator={false}
                keyExtractor={(item) => item.id.toString()}
                renderItem={({ item }) => (
                  <TouchableOpacity
                    style={styles.relatedCard}
                    onPress={() =>
                      router.push(`/media/${item.id}?type=${item.name ? 'tv' : 'movie'}`)
                    }
                  >
                    <Image
                      source={{
                        uri: item.poster_path
                          ? image185(item.poster_path)
                          : 'https://via.placeholder.com/185x278?text=No+Image',
                      }}
                      style={styles.relatedImage}
                    />
                    <Text style={styles.relatedTitle} numberOfLines={2}>
                      {item.title || item.name}
                    </Text>
                  </TouchableOpacity>
                )}
                contentContainerStyle={styles.relatedList}
              />
            </View>
          )}

          {/* Reviews */}
          {reviews.length > 0 && (
            <ReviewsSection
              reviews={reviews}
              mediaId={displayData.id?.toString() || id?.toString() || ''}
              mediaType={displayData.name ? 'tv' : 'movie'}
              title="Reviews"
            />
          )}
        </View>
      </Animated.ScrollView>

      {/* Quality Selection Modal */}
      <QualitySelectionModal
        visible={showQualityModal}
        onClose={() => setShowQualityModal(false)}
        onSelectQuality={handleQualitySelected}
        mediaTitle={displayData?.title || displayData?.name || ''}
        mediaType={displayData?.name ? 'tv' : 'movie'}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.neutral[950],
  },
  header: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    zIndex: 100,
    overflow: 'hidden',
  },
  headerImage: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    width: '100%',
    height: '100%',
  },
  headerContent: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.3)',
    paddingTop: Platform.OS === 'ios' ? 50 : 30,
    paddingHorizontal: 16,
  },
  headerTitleContainer: {
    position: 'absolute',
    top: Platform.OS === 'ios' ? 50 : 30,
    left: 16,
    right: 16,
    alignItems: 'center',
  },
  headerTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 18,
    color: Colors.neutral[100],
  },
  headerButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  rightButtons: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  actionButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 8,
  },
  downloadButton: {
    backgroundColor: Colors.primary[500],
  },
  favoriteButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  favoriteButtonActive: {
    backgroundColor: Colors.primary[500],
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    paddingTop: HEADER_HEIGHT,
  },
  content: {
    padding: 16,
  },
  title: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 24,
    color: Colors.neutral[100],
    marginBottom: 12,
  },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
    flexWrap: 'wrap',
  },
  infoItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 16,
    marginBottom: 8,
  },
  infoText: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: Colors.neutral[400],
    marginLeft: 6,
  },
  genresContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginBottom: 20,
  },
  genreChip: {
    backgroundColor: Colors.neutral[800],
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    marginRight: 8,
    marginBottom: 8,
  },
  genreText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: Colors.neutral[300],
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 18,
    color: Colors.neutral[100],
    marginBottom: 12,
  },
  overview: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: Colors.neutral[300],
    lineHeight: 20,
  },
  castList: {
    paddingRight: 16,
  },
  castCard: {
    marginRight: 12,
    width: 100,
  },
  castImage: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: Colors.neutral[800],
    marginBottom: 8,
  },
  castName: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: Colors.neutral[100],
    textAlign: 'center',
    marginBottom: 4,
  },
  castCharacter: {
    fontFamily: 'Inter-Regular',
    fontSize: 11,
    color: Colors.neutral[400],
    textAlign: 'center',
  },
  relatedList: {
    paddingRight: 16,
  },
  relatedCard: {
    marginRight: 12,
    width: 120,
  },
  relatedImage: {
    width: 120,
    height: 180,
    borderRadius: 8,
    backgroundColor: Colors.neutral[800],
    marginBottom: 8,
  },
  relatedTitle: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: Colors.neutral[100],
    textAlign: 'center',
  },
  errorContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: Colors.neutral[950],
    padding: 20,
  },
  errorText: {
    fontFamily: 'Inter-Medium',
    fontSize: 16,
    color: Colors.neutral[400],
    textAlign: 'center',
    marginBottom: 20,
  },
  retryButton: {
    backgroundColor: Colors.primary[500],
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8,
  },
  retryButtonText: {
    fontFamily: 'Inter-Medium',
    fontSize: 14,
    color: Colors.neutral[100],
  },
});
