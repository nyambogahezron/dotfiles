import Colors from '@/constants/Colors';
import AntDesign from '@expo/vector-icons/AntDesign';
// import { ExternalLink, Download } from 'lucide-react-native';
import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Image,
  ScrollView,
  Alert,
  Linking,
} from 'react-native';
import type { StreamingProvidersProps, WatchProvider } from '@repo/interfaces';

export default function StreamingProviders({
  title = 'Where to Watch',
  mediaTitle,
  watchProviders,
}: StreamingProvidersProps) {
  const getProvider = (type: 'flatrate' | 'rent' | 'buy'): WatchProvider | null => {
    // Find a provider from the array that supports the given type
    const provider = watchProviders.find(p => p.types === type);
    if (provider) {
      return {
        provider_id: Number(provider.providerId),
        provider_name: provider.name || '',
        logoUrl: provider.logoUrl || '',
        providerId: provider.providerId || '',
        country: provider.country || '',
        types: type,
        link: provider.link || '',
        flatrate: type,
        logo_path: provider.logoUrl || '',
      };
    }
    return null;
  };

  const handleProviderPress = (link?: string) => {
    if (link) {
      Linking.openURL(link);
    } else {
      Alert.alert('Not Available', 'No direct link available for this provider.');
    }
  };

  const handleDownload = () => {
    Alert.alert('Download Options', `Choose how you'd like to download "${mediaTitle}"`, [
      {
        text: 'High Quality (1080p)',
        onPress: () => simulateDownload('1080p'),
      },
      {
        text: 'Medium Quality (720p)',
        onPress: () => simulateDownload('720p'),
      },
      {
        text: 'Low Quality (480p)',
        onPress: () => simulateDownload('480p'),
      },
      {
        text: 'Cancel',
        style: 'cancel',
      },
    ]);
  };

  const simulateDownload = (quality: string) => {
    Alert.alert(
      'Download Started',
      `Downloading "${mediaTitle}" in ${quality}. You'll be notified when complete.`,
      [{ text: 'OK' }],
    );
    // TODO: Integrate with actual download service
  };

  const renderProviders = (providers: WatchProvider[], type: string) => {
    if (!providers || providers.length === 0) return null;

    return (
      <View style={styles.providerSection}>
        <Text style={styles.providerTypeTitle}>{type}</Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          {providers.map((provider) => (
            <TouchableOpacity
              key={provider.provider_id}
              style={styles.providerCard}
              onPress={() => handleProviderPress(provider.link)}
              activeOpacity={0.8}
            >
              <Image
                source={{
                  uri: `https://image.tmdb.org/t/p/w92${provider.logo_path}`,
                }}
                style={styles.providerLogo}
              />
              <Text style={styles.providerName} numberOfLines={2}>
                {provider.provider_name}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.sectionTitle}>{title}</Text>
        <TouchableOpacity style={styles.downloadButton} onPress={handleDownload}>
          <AntDesign name="clouddownloado" size={16} color={Colors.neutral[100]} />
          <Text style={styles.downloadButtonText}>Download</Text>
        </TouchableOpacity>
      </View>

      {/* Streaming Services */}
      {getProvider('flatrate') && renderProviders([getProvider('flatrate')!], 'Stream')}

      {/* Rental Services */}
      {getProvider('rent') && renderProviders([getProvider('rent')!], 'Rent')}

      {/* Purchase Services */}
      {getProvider('buy') && renderProviders([getProvider('buy')!], 'Buy')}

      {/* Link to TMDB */}
      {watchProviders.US && (
        <TouchableOpacity
          style={styles.linkButton}
          onPress={() => handleProviderPress(watchProviders.US)}
        >
          <AntDesign name="link" size={16} color={Colors.primary[400]} />
          <Text style={styles.linkButtonText}>View all options</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginBottom: 24,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  sectionTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 18,
    color: Colors.neutral[100],
  },
  downloadButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.primary[500],
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 6,
  },
  downloadButtonText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: Colors.neutral[100],
    marginLeft: 6,
  },
  providerSection: {
    marginBottom: 16,
  },
  providerTypeTitle: {
    fontFamily: 'Inter-Medium',
    fontSize: 14,
    color: Colors.neutral[300],
    marginBottom: 8,
  },
  providerCard: {
    alignItems: 'center',
    marginRight: 12,
    width: 80,
  },
  providerLogo: {
    width: 60,
    height: 60,
    borderRadius: 8,
    backgroundColor: Colors.neutral[800],
    marginBottom: 6,
  },
  providerName: {
    fontFamily: 'Inter-Regular',
    fontSize: 10,
    color: Colors.neutral[300],
    textAlign: 'center',
    lineHeight: 12,
  },
  linkButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    marginTop: 8,
  },
  linkButtonText: {
    fontFamily: 'Inter-Medium',
    fontSize: 14,
    color: Colors.primary[400],
    marginLeft: 6,
  },
});
