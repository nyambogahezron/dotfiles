import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Image, Alert } from 'react-native';
import Animated, { useAnimatedStyle, useSharedValue, withTiming } from 'react-native-reanimated';
import {
	User,
	Bell,
	Shield,
	Download,
	Upload,
	Camera,
	Moon,
	Sun,
	Globe,
	Lock,
	Smartphone,
	Mail,
} from 'lucide-react-native';
import { mockUserSettings } from '@/data/mockData';
import SettingsSection from '@/components/settings/SettingsSection';
import SettingsItem from '@/components/settings/SettingsItem';
import LoadingSpinner from '@/components/shared/LoadingSpinner';
import { UserSettings } from '@/types/project';

export default function SettingsScreen() {
	const [isLoading, setIsLoading] = React.useState(true);
	const [settings, setSettings] = React.useState<UserSettings>(mockUserSettings);

	const headerOpacity = useSharedValue(0);

	React.useEffect(() => {
		// Simulate loading
		setTimeout(() => {
			setIsLoading(false);
			headerOpacity.value = withTiming(1, { duration: 600 });
		}, 600);
	}, [headerOpacity]);

	const handleNotificationToggle = (key: keyof UserSettings['notifications']) => {
		setSettings((prev) => ({
			...prev,
			notifications: {
				...prev.notifications,
				[key]: !prev.notifications[key],
			},
		}));
	};

	const handleThemeChange = () => {
		const themes = ['light', 'dark', 'system'] as const;
		const currentIndex = themes.indexOf(settings.theme);
		const nextTheme = themes[(currentIndex + 1) % themes.length];
		setSettings((prev) => ({ ...prev, theme: nextTheme }));
	};

	const handleAvatarChange = () => {
		Alert.alert('Change Avatar', 'Choose an option', [
			{ text: 'Camera', onPress: () => console.log('Open camera') },
			{ text: 'Gallery', onPress: () => console.log('Open gallery') },
			{ text: 'Cancel', style: 'cancel' },
		]);
	};

	const handleExportData = () => {
		Alert.alert('Export Data', 'Your data export will be sent to your email address.');
	};

	const handleImportData = () => {
		Alert.alert('Import Data', 'Select a file to import your data.');
	};

	const handle2FAToggle = () => {
		if (!settings.twoFactorEnabled) {
			Alert.alert(
				'Enable Two-Factor Authentication',
				'This will add an extra layer of security to your account.',
				[
					{ text: 'Cancel', style: 'cancel' },
					{
						text: 'Enable',
						onPress: () => setSettings((prev) => ({ ...prev, twoFactorEnabled: true })),
					},
				],
			);
		} else {
			setSettings((prev) => ({ ...prev, twoFactorEnabled: false }));
		}
	};

	const headerAnimatedStyle = useAnimatedStyle(() => ({
		opacity: headerOpacity.value,
	}));

	if (isLoading) {
		return (
			<View style={styles.loadingContainer}>
				<LoadingSpinner size={32} />
				<Text style={styles.loadingText}>Loading settings...</Text>
			</View>
		);
	}

	return (
		<ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
			<Animated.View style={[styles.header, headerAnimatedStyle]}>
				<Text style={styles.title}>Settings</Text>
				<Text style={styles.subtitle}>Customize your TaskFlow experience</Text>
			</Animated.View>

			<View style={styles.content}>
				<SettingsSection title='Profile' index={0}>
					<View style={styles.profileHeader}>
						<TouchableOpacity onPress={handleAvatarChange} style={styles.avatarContainer}>
							<Image source={{ uri: settings.avatar }} style={styles.avatar} />
							<View style={styles.cameraOverlay}>
								<Camera size={16} color='#FFFFFF' />
							</View>
						</TouchableOpacity>
						<View style={styles.profileInfo}>
							<Text style={styles.profileName}>{settings.name}</Text>
							<Text style={styles.profileEmail}>{settings.email}</Text>
						</View>
					</View>
					<SettingsItem
						title='Edit Profile'
						subtitle='Update your personal information'
						icon={<User size={20} color='#3B82F6' />}
						onPress={() => console.log('Edit profile')}
					/>
				</SettingsSection>

				<SettingsSection title='Notifications' index={1}>
					<SettingsItem
						title='Email Notifications'
						subtitle='Receive updates via email'
						icon={<Mail size={20} color='#3B82F6' />}
						isSwitch
						switchValue={settings.notifications.email}
						onSwitchChange={() => handleNotificationToggle('email')}
						showChevron={false}
					/>
					<SettingsItem
						title='Push Notifications'
						subtitle='Get notified on your device'
						icon={<Smartphone size={20} color='#3B82F6' />}
						isSwitch
						switchValue={settings.notifications.push}
						onSwitchChange={() => handleNotificationToggle('push')}
						showChevron={false}
					/>
					<SettingsItem
						title='Task Reminders'
						subtitle='Reminders for upcoming deadlines'
						icon={<Bell size={20} color='#3B82F6' />}
						isSwitch
						switchValue={settings.notifications.taskReminders}
						onSwitchChange={() => handleNotificationToggle('taskReminders')}
						showChevron={false}
					/>
					<SettingsItem
						title='Project Updates'
						subtitle='Updates when projects change'
						icon={<Bell size={20} color='#3B82F6' />}
						isSwitch
						switchValue={settings.notifications.projectUpdates}
						onSwitchChange={() => handleNotificationToggle('projectUpdates')}
						showChevron={false}
					/>
					<SettingsItem
						title='Team Mentions'
						subtitle='When someone mentions you'
						icon={<Bell size={20} color='#3B82F6' />}
						isSwitch
						switchValue={settings.notifications.teamMentions}
						onSwitchChange={() => handleNotificationToggle('teamMentions')}
						showChevron={false}
						isLast
					/>
				</SettingsSection>

				<SettingsSection title='Security' index={2}>
					<SettingsItem
						title='Two-Factor Authentication'
						subtitle={settings.twoFactorEnabled ? 'Enabled' : 'Add extra security to your account'}
						icon={<Shield size={20} color='#3B82F6' />}
						isSwitch
						switchValue={settings.twoFactorEnabled}
						onSwitchChange={handle2FAToggle}
						showChevron={false}
					/>
					<SettingsItem
						title='Change Password'
						subtitle='Update your account password'
						icon={<Lock size={20} color='#3B82F6' />}
						onPress={() => console.log('Change password')}
						isLast
					/>
				</SettingsSection>

				<SettingsSection title='Appearance' index={3}>
					<SettingsItem
						title='Theme'
						subtitle='Choose your preferred theme'
						value={settings.theme.charAt(0).toUpperCase() + settings.theme.slice(1)}
						icon={
							settings.theme === 'dark' ? (
								<Moon size={20} color='#3B82F6' />
							) : (
								<Sun size={20} color='#3B82F6' />
							)
						}
						onPress={handleThemeChange}
					/>
					<SettingsItem
						title='Language'
						subtitle='Select your language'
						value='English'
						icon={<Globe size={20} color='#3B82F6' />}
						onPress={() => console.log('Change language')}
						isLast
					/>
				</SettingsSection>

				<SettingsSection title='Data Management' index={4}>
					<SettingsItem
						title='Export Data'
						subtitle='Download your data as JSON'
						icon={<Download size={20} color='#3B82F6' />}
						onPress={handleExportData}
					/>
					<SettingsItem
						title='Import Data'
						subtitle='Import data from a backup file'
						icon={<Upload size={20} color='#3B82F6' />}
						onPress={handleImportData}
						isLast
					/>
				</SettingsSection>
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
	title: {
		fontSize: 28,
		fontWeight: '700',
		color: '#1F2937',
		marginBottom: 8,
	},
	subtitle: {
		fontSize: 14,
		color: '#6B7280',
	},
	content: {
		paddingHorizontal: 24,
		paddingBottom: 32,
	},
	profileHeader: {
		flexDirection: 'row',
		alignItems: 'center',
		padding: 20,
		borderBottomWidth: 1,
		borderBottomColor: '#F3F4F6',
	},
	avatarContainer: {
		position: 'relative',
		marginRight: 16,
	},
	avatar: {
		width: 64,
		height: 64,
		borderRadius: 32,
	},
	cameraOverlay: {
		position: 'absolute',
		bottom: 0,
		right: 0,
		width: 24,
		height: 24,
		borderRadius: 12,
		backgroundColor: '#3B82F6',
		justifyContent: 'center',
		alignItems: 'center',
		borderWidth: 2,
		borderColor: '#FFFFFF',
	},
	profileInfo: {
		flex: 1,
	},
	profileName: {
		fontSize: 18,
		fontWeight: '600',
		color: '#1F2937',
		marginBottom: 4,
	},
	profileEmail: {
		fontSize: 14,
		color: '#6B7280',
	},
});
