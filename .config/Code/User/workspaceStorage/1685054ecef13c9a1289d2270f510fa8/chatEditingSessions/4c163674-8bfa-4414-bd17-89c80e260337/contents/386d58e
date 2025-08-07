import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Plus, Calendar, Users, ChartBar as BarChart3 } from 'lucide-react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { router } from 'expo-router';

const ONBOARDING_STORAGE_KEY = '@TaskFlow:hasSeenOnboarding';

export default function HomeScreen() {
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const checkOnboardingStatus = async () => {
      try {
        // Clear onboarding status for testing (remove this line in production)
        await AsyncStorage.removeItem(ONBOARDING_STORAGE_KEY);
        
        const hasSeenOnboarding = await AsyncStorage.getItem(ONBOARDING_STORAGE_KEY);
        
        if (hasSeenOnboarding !== 'true') {
          // User hasn't seen onboarding, redirect to onboarding screen
          router.replace('/(tabs)/onboarding');
          return;
        }
        
        // User has seen onboarding, continue to home screen
        setIsLoading(false);
      } catch (error) {
        console.error('Error checking onboarding status:', error);
        // Default to showing onboarding if there's an error
        router.replace('/(tabs)/onboarding');
      }
    };

    checkOnboardingStatus();
  }, []);

  if (isLoading) {
    return (
      <View style={[styles.container, { justifyContent: 'center', alignItems: 'center' }]}>
        <ActivityIndicator size="large" color="#3B82F6" />
        <Text style={{ marginTop: 16, fontSize: 16, color: '#6B7280' }}>Loading...</Text>
      </View>
    );
  }
  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      <View style={styles.header}>
        <Text style={styles.greeting}>Good morning! 👋</Text>
        <Text style={styles.welcome}>Welcome to TaskFlow</Text>
      </View>

      <View style={styles.statsContainer}>
        <View style={styles.statCard}>
          <BarChart3 size={24} color="#3B82F6" />
          <Text style={styles.statNumber}>12</Text>
          <Text style={styles.statLabel}>Active Projects</Text>
        </View>
        <View style={styles.statCard}>
          <Calendar size={24} color="#10B981" />
          <Text style={styles.statNumber}>24</Text>
          <Text style={styles.statLabel}>Tasks Due</Text>
        </View>
        <View style={styles.statCard}>
          <Users size={24} color="#8B5CF6" />
          <Text style={styles.statNumber}>8</Text>
          <Text style={styles.statLabel}>Team Members</Text>
        </View>
      </View>

      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Recent Projects</Text>
          <TouchableOpacity style={styles.addButton}>
            <Plus size={20} color="#3B82F6" />
          </TouchableOpacity>
        </View>

        <View style={styles.projectCard}>
          <View style={styles.projectHeader}>
            <Text style={styles.projectTitle}>Mobile App Redesign</Text>
            <Text style={styles.projectStatus}>In Progress</Text>
          </View>
          <Text style={styles.projectDescription}>
            Updating the user interface and user experience of our mobile application
          </Text>
          <View style={styles.projectProgress}>
            <View style={styles.progressBar}>
              <View style={[styles.progressFill, { width: '65%' }]} />
            </View>
            <Text style={styles.progressText}>65%</Text>
          </View>
        </View>

        <View style={styles.projectCard}>
          <View style={styles.projectHeader}>
            <Text style={styles.projectTitle}>Website Launch</Text>
            <Text style={styles.projectStatus}>Planning</Text>
          </View>
          <Text style={styles.projectDescription}>
            Planning and executing the launch of our new company website
          </Text>
          <View style={styles.projectProgress}>
            <View style={styles.progressBar}>
              <View style={[styles.progressFill, { width: '30%' }]} />
            </View>
            <Text style={styles.progressText}>30%</Text>
          </View>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  header: {
    padding: 24,
    paddingTop: 60,
  },
  greeting: {
    fontSize: 16,
    color: '#6B7280',
    marginBottom: 4,
  },
  welcome: {
    fontSize: 28,
    fontWeight: '700',
    color: '#1F2937',
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: 24,
    marginBottom: 32,
  },
  statCard: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 20,
    marginHorizontal: 4,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },
  statNumber: {
    fontSize: 24,
    fontWeight: '700',
    color: '#1F2937',
    marginTop: 8,
  },
  statLabel: {
    fontSize: 12,
    color: '#6B7280',
    marginTop: 4,
    textAlign: 'center',
  },
  section: {
    paddingHorizontal: 24,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#1F2937',
  },
  addButton: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: '#EBF4FF',
    justifyContent: 'center',
    alignItems: 'center',
  },
  projectCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 20,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },
  projectHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  projectTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1F2937',
    flex: 1,
  },
  projectStatus: {
    fontSize: 12,
    fontWeight: '500',
    color: '#3B82F6',
    backgroundColor: '#EBF4FF',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  projectDescription: {
    fontSize: 14,
    color: '#6B7280',
    lineHeight: 20,
    marginBottom: 16,
  },
  projectProgress: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  progressBar: {
    flex: 1,
    height: 8,
    backgroundColor: '#F3F4F6',
    borderRadius: 4,
    marginRight: 12,
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#3B82F6',
    borderRadius: 4,
  },
  progressText: {
    fontSize: 14,
    fontWeight: '500',
    color: '#6B7280',
  },
});