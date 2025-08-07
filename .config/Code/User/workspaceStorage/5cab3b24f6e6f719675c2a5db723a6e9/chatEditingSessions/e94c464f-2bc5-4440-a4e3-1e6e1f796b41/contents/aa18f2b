import CommentsBottomSheet from '@/components/CommentsBottomSheet';
import MediaMiniCard from '@/components/MediaMiniCard';
import RatingStars from '@/components/RatingStars';
import UserAvatar from '@/components/UserAvatar';
import Colors from '@/constants/Colors';
import { useFeed } from '@repo/services';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { useState } from 'react';
import { Platform, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';

export default function PostDetailsScreen() {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const [isFavorite, setIsFavorite] = useState(false);
  const [isCommentsVisible, setIsCommentsVisible] = useState(false);

  // Get post data
  const { data: postsData } = useFeed();

  // Transform API data to find the specific post
  const posts =
    postsData?.map((post: any) => ({
      id: post.id,
      user: {
        id: post.user.id,
        name: post.user.name,
        username: post.user.username,
        email: post.user.email,
        avatar: post.user.avatar,
      },
      media: {
        id: post.movie?.tmdbId || post.id,
        title: post.movie?.title || 'Unknown',
        posterUrl: post.movie?.posterPath || '',
        type: post.movie?.mediaType || 'movie',
        year: post.movie?.releaseDate ? new Date(post.movie.releaseDate).getFullYear() : 2024,
        genres: post.movie?.genres || [],
        rating: post.rating || 0,
        description: post.movie?.overview || '',
        releaseDate: post.movie?.releaseDate || '',
        duration: post.movie?.runtime || 0,
        progress: {
          current: 0,
          total: 100,
        },
        status: 'Completed',
        rewatches: 0,
        favorite: false,
      },
      rating: post.rating || 0,
      review: post.content || '',
      timeAgo: post.createdAt ? new Date(post.createdAt).toLocaleDateString() : 'Unknown',
      likes: post.likes || 0,
      comments: post.comments || 0,
    })) || [];

  const post = posts.find((item: any) => item.id.toString() === id);

  if (!post) {
    return (
      <View style={styles.errorContainer}>
        <Text style={styles.errorText}>Post not found</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
          <Ionicons name="chevron-back" size={24} color={Colors.neutral[100]} />
        </TouchableOpacity>
      </View>

      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Post Header */}
        <View style={styles.postHeader}>
          <UserAvatar user={post.user} size={48} />
          <View style={styles.postHeaderText}>
            <Text style={styles.userName}>{post.user.name}</Text>
            <Text style={styles.postTime}>{post.timeAgo}</Text>
          </View>
        </View>

        {/* Media Card */}
        <MediaMiniCard media={post.media} />

        {/* Post Content */}
        <View style={styles.postContent}>
          <View style={styles.ratingContainer}>
            <RatingStars rating={post.rating} size={20} />
            <Text style={styles.ratingText}>{post.rating}/5</Text>
          </View>

          <Text style={styles.reviewText}>{post.review}</Text>
        </View>

        {/* Post Actions */}
        <View style={styles.postActions}>
          <TouchableOpacity style={styles.actionButton} onPress={() => setIsFavorite(!isFavorite)}>
            <Ionicons
              name="heart"
              size={24}
              color={isFavorite ? Colors.primary[500] : Colors.neutral[400]}
            />
            <Text style={[styles.actionText, isFavorite && styles.actionTextActive]}>
              {post.likes}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.actionButton} onPress={() => setIsCommentsVisible(true)}>
            <Ionicons name="chatbubble" size={24} color={Colors.neutral[400]} />
            <Text style={styles.actionText}>{post.comments}</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.actionButton}>
            <Ionicons name="share" size={24} color={Colors.neutral[400]} />
          </TouchableOpacity>
        </View>
      </ScrollView>

      {/* Comments Bottom Sheet */}
      <CommentsBottomSheet
        isVisible={isCommentsVisible}
        onClose={() => setIsCommentsVisible(false)}
        postId={post.id}
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
    paddingTop: Platform.OS === 'ios' ? 50 : 30,
    paddingHorizontal: 16,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    paddingTop: Platform.OS === 'ios' ? 100 : 80,
    padding: 16,
  },
  postHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  postHeaderText: {
    marginLeft: 12,
  },
  userName: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 18,
    color: Colors.neutral[100],
  },
  postTime: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: Colors.neutral[500],
  },
  postContent: {
    marginTop: 16,
  },
  ratingContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  ratingText: {
    fontFamily: 'Inter-Medium',
    fontSize: 16,
    color: Colors.accent[500],
    marginLeft: 8,
  },
  reviewText: {
    fontFamily: 'Inter-Regular',
    fontSize: 16,
    color: Colors.neutral[200],
    lineHeight: 24,
  },
  postActions: {
    flexDirection: 'row',
    marginTop: 24,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: Colors.neutral[800],
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 24,
  },
  actionText: {
    fontFamily: 'Inter-Medium',
    fontSize: 16,
    color: Colors.neutral[400],
    marginLeft: 8,
  },
  actionTextActive: {
    color: Colors.primary[500],
  },
  errorContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: Colors.neutral[950],
  },
  errorText: {
    fontFamily: 'Inter-Medium',
    fontSize: 16,
    color: Colors.neutral[400],
  },
});
