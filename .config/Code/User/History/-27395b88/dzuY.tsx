'use client';

'use client';

import React, { useState } from 'react';
import { User, Mail, Calendar, Edit, LogOut } from 'lucide-react';
import { useWebAuth } from '../../context/AuthContext';
import { useUserAnalytics } from '@repo/services';

const Profile: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'profile' | 'settings' | 'privacy'>('profile');
  const { user, logout } = useWebAuth();
  const { data: analytics } = useUserAnalytics();

  const handleLogout = async () => {
    try {
      await logout();
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  if (!user) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-gray-400">Loading profile...</p>
        </div>
      </div>
    );
  }

  // User data from server
  const userData = {
    name: user.firstName && user.lastName ? `${user.firstName} ${user.lastName}` : user.username,
    username: user.username,
    email: user.email,
    joinDate: new Date(user.createdAt).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }),
    avatar:
      user.avatar ||
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    watchTime: analytics?.totalWatched || 0,
    moviesWatched: analytics?.totalMovies || 0,
    tvShowsWatched: analytics?.totalTVShows || 0,
    followers: 0, // TODO: Add social features to server
    following: 0, // TODO: Add social features to server
  };

  return (
    <div className="container-custom py-8">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-white mb-2">Profile</h1>
          <p className="text-gray-400">Manage your account and preferences</p>
        </div>

        {/* Tab Navigation */}
        <div className="bg-gray-800 rounded-lg p-6 mb-8">
          <div className="flex gap-2 mb-6">
            <button
              className={`px-4 py-2 rounded-lg transition-colors ${
                activeTab === 'profile'
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
              onClick={() => setActiveTab('profile')}
            >
              Profile
            </button>
            <button
              className={`px-4 py-2 rounded-lg transition-colors ${
                activeTab === 'settings'
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
              onClick={() => setActiveTab('settings')}
            >
              Settings
            </button>
            <button
              className={`px-4 py-2 rounded-lg transition-colors ${
                activeTab === 'privacy'
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
              onClick={() => setActiveTab('privacy')}
            >
              Privacy
            </button>
          </div>

          {/* Tab Content */}
          <div className="min-h-[400px]">
            {activeTab === 'profile' && (
              <div className="space-y-6">
                {/* Profile Header */}
                <div className="flex items-center space-x-6">
                  <img
                    src={userData.avatar}
                    alt={userData.name}
                    className="w-24 h-24 rounded-full object-cover"
                  />
                  <div>
                    <h2 className="text-2xl font-bold text-white">{userData.name}</h2>
                    <p className="text-gray-400">@{userData.username}</p>
                    <p className="text-gray-500 text-sm">Member since {userData.joinDate}</p>
                  </div>
                  <button className="ml-auto flex items-center px-4 py-2 bg-gray-700 text-gray-300 rounded-lg hover:bg-gray-600 transition-colors">
                    <Edit className="h-4 w-4 mr-2" />
                    Edit Profile
                  </button>
                </div>

                {/* Stats Grid */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div className="bg-gray-700 p-4 rounded-lg text-center">
                    <div className="text-2xl font-bold text-white">{userData.watchTime}</div>
                    <div className="text-sm text-gray-400">Items Watched</div>
                  </div>
                  <div className="bg-gray-700 p-4 rounded-lg text-center">
                    <div className="text-2xl font-bold text-white">{userData.moviesWatched}</div>
                    <div className="text-sm text-gray-400">Movies</div>
                  </div>
                  <div className="bg-gray-700 p-4 rounded-lg text-center">
                    <div className="text-2xl font-bold text-white">{userData.tvShowsWatched}</div>
                    <div className="text-sm text-gray-400">TV Shows</div>
                  </div>
                  <div className="bg-gray-700 p-4 rounded-lg text-center">
                    <div className="text-2xl font-bold text-white">{userData.followers}</div>
                    <div className="text-sm text-gray-400">Followers</div>
                  </div>
                </div>

                {/* Contact Information */}
                <div className="bg-gray-700 rounded-lg p-6">
                  <h3 className="text-lg font-semibold text-white mb-4">Contact Information</h3>
                  <div className="space-y-3">
                    <div className="flex items-center">
                      <Mail className="h-4 w-4 text-gray-400 mr-3" />
                      <span className="text-gray-300">{userData.email}</span>
                    </div>
                    <div className="flex items-center">
                      <User className="h-4 w-4 text-gray-400 mr-3" />
                      <span className="text-gray-300">{userData.username}</span>
                    </div>
                    <div className="flex items-center">
                      <Calendar className="h-4 w-4 text-gray-400 mr-3" />
                      <span className="text-gray-300">Joined {userData.joinDate}</span>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {activeTab === 'settings' && (
              <div className="space-y-6">
                <h3 className="text-lg font-semibold text-white mb-4">Account Settings</h3>
                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-gray-700 rounded-lg">
                    <div>
                      <h4 className="font-medium text-white">Email Notifications</h4>
                      <p className="text-sm text-gray-400">Receive updates about new releases</p>
                    </div>
                    <button className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                      Enable
                    </button>
                  </div>
                  <div className="flex items-center justify-between p-4 bg-gray-700 rounded-lg">
                    <div>
                      <h4 className="font-medium text-white">Dark Mode</h4>
                      <p className="text-sm text-gray-400">Use dark theme for better viewing</p>
                    </div>
                    <button className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-500 transition-colors">
                      Enabled
                    </button>
                  </div>
                </div>
              </div>
            )}

            {activeTab === 'privacy' && (
              <div className="space-y-6">
                <h3 className="text-lg font-semibold text-white mb-4">Privacy Settings</h3>
                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-gray-700 rounded-lg">
                    <div>
                      <h4 className="font-medium text-white">Public Profile</h4>
                      <p className="text-sm text-gray-400">Allow others to see your watchlist</p>
                    </div>
                    <button className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                      Public
                    </button>
                  </div>
                  <div className="flex items-center justify-between p-4 bg-gray-700 rounded-lg">
                    <div>
                      <h4 className="font-medium text-white">Activity Feed</h4>
                      <p className="text-sm text-gray-400">Share your watching activity</p>
                    </div>
                    <button className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-500 transition-colors">
                      Private
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Logout Button */}
        <div className="text-center">
          <button
            onClick={handleLogout}
            className="flex items-center mx-auto px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
          >
            <LogOut className="h-4 w-4 mr-2" />
            Logout
          </button>
        </div>
      </div>
    </div>
  );
};

export default Profile;
