import Colors from '@/constants/Colors';
import {  } from '@repo/context';
import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Image,
  Alert,
  RefreshControl,
} from 'react-native';
import { image185 } from '@repo/services';
import { useRouter } from 'expo-router';
import EmptyState from '@/components/EmptyState';

export default function DownloadsScreen() {
  const { downloads, removeDownload, pauseDownload, resumeDownload, refreshDownloads } =
    useDownloads();
  const router = useRouter();
  const [refreshing, setRefreshing] = React.useState(false);

  const onRefresh = React.useCallback(async () => {
    setRefreshing(true);
    await refreshDownloads();
    setRefreshing(false);
  }, [refreshDownloads]);

  const handleRemoveDownload = (id: string, title: string) => {
    Alert.alert('Remove Download', `Are you sure you want to remove "${title}" from downloads?`, [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Remove',
        style: 'destructive',
        onPress: () => removeDownload(id),
      },
    ]);
  };

  const getProgressColor = (status: string) => {
    switch (status) {
      case 'completed':
        return Colors.success[500];
      case 'downloading':
        return Colors.primary[500];
      case 'paused':
        return Colors.warning[500];
      case 'failed':
        return Colors.error[500];
      default:
        return Colors.neutral[500];
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'downloading':
        return 'Downloading';
      case 'paused':
        return 'Paused';
      case 'failed':
        return 'Failed';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  };

  const renderDownloadItem = ({ item }: { item: any }) => (
    <View style={styles.downloadCard}>
      <TouchableOpacity
        style={styles.downloadContent}
        onPress={() => router.push(`/media/${item.mediaId}?type=${item.mediaType}`)}
      >
        <Image
          source={{
            uri: item.posterPath
              ? image185(item.posterPath)
              : 'https://via.placeholder.com/185x278?text=No+Image',
          }}
          style={styles.poster}
        />

        <View style={styles.downloadInfo}>
          <Text style={styles.title} numberOfLines={2}>
            {item.title}
          </Text>

          <View style={styles.mediaInfo}>
            <Text style={styles.mediaType}>{item.mediaType === 'tv' ? 'TV Show' : 'Movie'}</Text>
            {item.quality && <Text style={styles.qualityText}>• {item.quality}</Text>}
          </View>

          <View style={styles.progressContainer}>
            <View style={styles.progressBar}>
              <View
                style={[
                  styles.progressFill,
                  {
                    width: `${item.progress}%`,
                    backgroundColor: getProgressColor(item.status),
                  },
                ]}
              />
            </View>
            <Text style={styles.progressText}>{item.progress}%</Text>
          </View>

          <View style={styles.statusRow}>
            <Text style={[styles.statusText, { color: getProgressColor(item.status) }]}>
              {getStatusText(item.status)}
            </Text>

            {item.fileSize && (
              <Text style={styles.fileSizeText}>
                {item.downloadedSize ? `${item.downloadedSize} / ` : ''}
                {item.fileSize}
              </Text>
            )}
          </View>

          {item.downloadSpeed && item.status === 'downloading' && (
            <Text style={styles.speedText}>
              {item.downloadSpeed}/s • {item.eta} remaining
            </Text>
          )}
        </View>
      </TouchableOpacity>

      <View style={styles.downloadActions}>
        {item.status === 'downloading' && (
          <TouchableOpacity style={styles.actionButton} onPress={() => pauseDownload(item.id)}>
            <Ionicons name="pause" size={18} color={Colors.neutral[300]} />
          </TouchableOpacity>
        )}

        {item.status === 'paused' && (
          <TouchableOpacity style={styles.actionButton} onPress={() => resumeDownload(item.id)}>
            <Ionicons name="play" size={18} color={Colors.neutral[300]} />
          </TouchableOpacity>
        )}

        <TouchableOpacity
          style={styles.actionButton}
          onPress={() => handleRemoveDownload(item.id, item.title)}
        >
          <Ionicons name="trash" size={18} color={Colors.error[400]} />
        </TouchableOpacity>
      </View>
    </View>
  );

  const activeDownloads = downloads.filter(
    (d) => d.status === 'downloading' || d.status === 'pending',
  );
  const completedDownloads = downloads.filter((d) => d.status === 'completed');
  const pausedDownloads = downloads.filter((d) => d.status === 'paused');
  const failedDownloads = downloads.filter((d) => d.status === 'failed');

  if (downloads.length === 0) {
    return (
      <View style={styles.container}>
        <EmptyState
          icon={<Ionicons name="download" size={48} />}
          message="No Downloads"
          subMessage="Start downloading movies and TV shows to watch offline"
          actionText="Browse Content"
          action={() => router.push('/(tabs)')}
        />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <FlatList
        data={[
          ...(activeDownloads.length > 0
            ? [
                {
                  type: 'section',
                  title: 'Active Downloads',
                  data: activeDownloads,
                },
              ]
            : []),
          ...(completedDownloads.length > 0
            ? [
                {
                  type: 'section',
                  title: 'Completed',
                  data: completedDownloads,
                },
              ]
            : []),
          ...(pausedDownloads.length > 0
            ? [{ type: 'section', title: 'Paused', data: pausedDownloads }]
            : []),
          ...(failedDownloads.length > 0
            ? [{ type: 'section', title: 'Failed', data: failedDownloads }]
            : []),
        ]}
        renderItem={({ item }) => (
          <View>
            <Text style={styles.sectionTitle}>{item.title}</Text>
            <FlatList
              data={item.data}
              renderItem={renderDownloadItem}
              keyExtractor={(download) => download.id}
              scrollEnabled={false}
            />
          </View>
        )}
        keyExtractor={(item, index) => `${item.type}-${index}`}
        contentContainerStyle={styles.scrollContent}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
            tintColor={Colors.primary[500]}
          />
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.neutral[950],
  },
  scrollContent: {
    padding: 16,
  },
  sectionTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 18,
    color: Colors.neutral[100],
    marginBottom: 12,
    marginTop: 8,
  },
  downloadCard: {
    backgroundColor: Colors.neutral[900],
    borderRadius: 12,
    marginBottom: 12,
    overflow: 'hidden',
    flexDirection: 'row',
    alignItems: 'center',
  },
  downloadContent: {
    flexDirection: 'row',
    flex: 1,
    padding: 12,
  },
  poster: {
    width: 60,
    height: 90,
    borderRadius: 8,
    backgroundColor: Colors.neutral[800],
  },
  downloadInfo: {
    flex: 1,
    marginLeft: 12,
    justifyContent: 'space-between',
  },
  title: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
    color: Colors.neutral[100],
    marginBottom: 4,
  },
  mediaType: {
    fontFamily: 'Inter-Regular',
    fontSize: 12,
    color: Colors.neutral[400],
  },
  mediaInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  qualityText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: Colors.primary[400],
    marginLeft: 4,
  },
  progressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  progressBar: {
    flex: 1,
    height: 4,
    backgroundColor: Colors.neutral[700],
    borderRadius: 2,
    marginRight: 8,
  },
  progressFill: {
    height: '100%',
    borderRadius: 2,
  },
  progressText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: Colors.neutral[300],
    minWidth: 35,
  },
  statusRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 4,
  },
  statusText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
  },
  fileSizeText: {
    fontFamily: 'Inter-Regular',
    fontSize: 11,
    color: Colors.neutral[400],
  },
  speedText: {
    fontFamily: 'Inter-Regular',
    fontSize: 11,
    color: Colors.neutral[400],
  },
  downloadActions: {
    flexDirection: 'row',
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  actionButton: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: Colors.neutral[800],
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 8,
  },
});
