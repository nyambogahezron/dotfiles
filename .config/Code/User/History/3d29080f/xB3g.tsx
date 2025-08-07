import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, TextInput } from 'react-native';
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import { Search, UserPlus, Filter, Users } from 'lucide-react-native';
import { mockTeamMembers } from '@/data/mockData';
import TeamMemberCard from '@/components/team/TeamMemberCard';
import LoadingSpinner from '@/components/shared/LoadingSpinner';
import { TeamMember } from '@/types/project';

export default function TeamScreen() {
  const [searchQuery, setSearchQuery] = React.useState('');
  const [isLoading, setIsLoading] = React.useState(true);
  const [filteredMembers, setFilteredMembers] = React.useState(mockTeamMembers);
  const [selectedDepartment, setSelectedDepartment] = React.useState<string | null>(null);

  const headerOpacity = useSharedValue(0);

  React.useEffect(() => {
    // Simulate loading
    setTimeout(() => {
      setIsLoading(false);
      headerOpacity.value = withTiming(1, { duration: 600 });
    }, 800);
  }, [headerOpacity]);

  React.useEffect(() => {
    let filtered = mockTeamMembers.filter(member =>
      member.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      member.role.toLowerCase().includes(searchQuery.toLowerCase()) ||
      member.department.toLowerCase().includes(searchQuery.toLowerCase())
    );

    if (selectedDepartment) {
      filtered = filtered.filter(member => member.department === selectedDepartment);
    }

    setFilteredMembers(filtered);
  }, [searchQuery, selectedDepartment]);

  const handleMemberPress = (member: TeamMember) => {
    console.log('Member pressed:', member.name);
    // Navigate to member profile
  };

  const handleInviteMember = () => {
    console.log('Invite new member');
    // Navigate to invite flow
  };

  const departments = Array.from(new Set(mockTeamMembers.map(m => m.department)));
  const onlineMembers = mockTeamMembers.filter(m => m.status === 'online').length;

  const headerAnimatedStyle = useAnimatedStyle(() => ({
    opacity: headerOpacity.value,
  }));

  if (isLoading) {
    return (
      <View style={styles.loadingContainer}>
        <LoadingSpinner size={32} />
        <Text style={styles.loadingText}>Loading team members...</Text>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      <Animated.View style={[styles.header, headerAnimatedStyle]}>
        <View style={styles.titleContainer}>
          <Text style={styles.title}>Team</Text>
          <TouchableOpacity onPress={handleInviteMember} style={styles.inviteButton}>
            <UserPlus size={20} color="#FFFFFF" />
          </TouchableOpacity>
        </View>

        <View style={styles.searchContainer}>
          <View style={styles.searchInputContainer}>
            <Search size={20} color="#9CA3AF" />
            <TextInput
              style={styles.searchInput}
              placeholder="Search team members..."
              value={searchQuery}
              onChangeText={setSearchQuery}
              placeholderTextColor="#9CA3AF"
            />
          </View>
          <TouchableOpacity style={styles.filterButton}>
            <Filter size={20} color="#6B7280" />
          </TouchableOpacity>
        </View>

        <View style={styles.statsRow}>
          <View style={styles.statItem}>
            <Users size={24} color="#3B82F6" />
            <Text style={styles.statNumber}>{mockTeamMembers.length}</Text>
            <Text style={styles.statLabel}>Total Members</Text>
          </View>
          <View style={styles.statItem}>
            <View style={[styles.statusDot, { backgroundColor: '#10B981' }]} />
            <Text style={styles.statNumber}>{onlineMembers}</Text>
            <Text style={styles.statLabel}>Online Now</Text>
          </View>
          <View style={styles.statItem}>
            <View style={styles.departmentIcon}>
              <Text style={styles.departmentIconText}>{departments.length}</Text>
            </View>
            <Text style={styles.statNumber}>{departments.length}</Text>
            <Text style={styles.statLabel}>Departments</Text>
          </View>
        </View>
      </Animated.View>

      <View style={styles.content}>
        <View style={styles.departmentFilters}>
          <ScrollView horizontal showsHorizontalScrollIndicator={false}>
            <TouchableOpacity
              onPress={() => setSelectedDepartment(null)}
              style={[
                styles.departmentFilter,
                !selectedDepartment && styles.departmentFilterActive,
              ]}
            >
              <Text style={[
                styles.departmentFilterText,
                !selectedDepartment && styles.departmentFilterTextActive,
              ]}>
                All
              </Text>
            </TouchableOpacity>
            {departments.map(department => (
              <TouchableOpacity
                key={department}
                onPress={() => setSelectedDepartment(department)}
                style={[
                  styles.departmentFilter,
                  selectedDepartment === department && styles.departmentFilterActive,
                ]}
              >
                <Text style={[
                  styles.departmentFilterText,
                  selectedDepartment === department && styles.departmentFilterTextActive,
                ]}>
                  {department}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        <View style={styles.membersSection}>
          <Text style={styles.sectionTitle}>
            Team Members ({filteredMembers.length})
          </Text>
          {filteredMembers.map((member, index) => (
            <TeamMemberCard
              key={member.id}
              member={member}
              index={index}
              onPress={handleMemberPress}
            />
          ))}
          {filteredMembers.length === 0 && (
            <View style={styles.emptyState}>
              <Text style={styles.emptyText}>No team members found</Text>
              <Text style={styles.emptySubtext}>Try adjusting your search or filters</Text>
            </View>
          )}
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
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F8FAFC',
  },
  loadingText: {
    fontSize: 16,
    color: '#6B7280',
    marginTop: 16,
  },
  header: {
    padding: 24,
    paddingTop: 60,
  },
  titleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: '#1F2937',
  },
  inviteButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#3B82F6',
    justifyContent: 'center',
    alignItems: 'center',
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 24,
  },
  searchInputContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 12,
    marginRight: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  searchInput: {
    flex: 1,
    fontSize: 16,
    color: '#1F2937',
    marginLeft: 12,
  },
  filterButton: {
    width: 44,
    height: 44,
    borderRadius: 12,
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  statItem: {
    flex: 1,
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    paddingVertical: 16,
    borderRadius: 12,
    marginHorizontal: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  statNumber: {
    fontSize: 20,
    fontWeight: '700',
    color: '#1F2937',
    marginTop: 8,
    marginBottom: 4,
  },
  statLabel: {
    fontSize: 12,
    color: '#6B7280',
    textAlign: 'center',
  },
  statusDot: {
    width: 24,
    height: 24,
    borderRadius: 12,
  },
  departmentIcon: {
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: '#3B82F6',
    justifyContent: 'center',
    alignItems: 'center',
  },
  departmentIconText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  content: {
    paddingHorizontal: 24,
  },
  departmentFilters: {
    marginBottom: 24,
  },
  departmentFilter: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: '#FFFFFF',
    marginRight: 8,
    borderWidth: 1,
    borderColor: '#E5E7EB',
  },
  departmentFilterActive: {
    backgroundColor: '#3B82F6',
    borderColor: '#3B82F6',
  },
  departmentFilterText: {
    fontSize: 14,
    fontWeight: '500',
    color: '#6B7280',
  },
  departmentFilterTextActive: {
    color: '#FFFFFF',
  },
  membersSection: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#1F2937',
    marginBottom: 16,
  },
  emptyState: {
    alignItems: 'center',
    paddingVertical: 40,
  },
  emptyText: {
    fontSize: 16,
    fontWeight: '500',
    color: '#374151',
    marginBottom: 4,
  },
  emptySubtext: {
    fontSize: 16,
    color: '#6B7280',
  },
});