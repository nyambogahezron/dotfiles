import React, { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import {
  useLogin,
  useRegister,
  useLogout,
  useCurrentUser,
  useRequestPasswordReset,
  useResetPassword,
  type LoginRequest,
  type RegisterRequest,
} from '@repo/services';
import { Alert } from 'react-native';

import AsyncStorage from '@react-native-async-storage/async-storage';

interface AuthContextType {
  // User state
  user: any | null;
  isAuthenticated: boolean;
  isLoading: boolean;

  // Auth actions
  login: (credentials: LoginRequest) => Promise<void>;
  register: (userData: RegisterRequest) => Promise<void>;
  logout: () => Promise<void>;
  requestPasswordReset: (email: string) => Promise<void>;
  resetPassword: (token: string, newPassword: string) => Promise<void>;

  // Loading states
  isLoginLoading: boolean;
  isRegisterLoading: boolean;
  isPasswordResetLoading: boolean;

  // Error states
  authError: string | null;
  clearError: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useServerAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useServerAuth must be used within a ServerAuthProvider');
  }
  return context;
};

interface ServerAuthProviderProps {
  children: ReactNode;
}

export const ServerAuthProvider = ({ children }: ServerAuthProviderProps) => {
  const [isInitialized, setIsInitialized] = useState(false);
  const [authError, setAuthError] = useState<string | null>(null);

  // Query hooks
  const { data: user, isLoading: userLoading, error: userError } = useCurrentUser();

  // Mutation hooks
  const loginMutation = useLogin();
  const registerMutation = useRegister();
  const logoutMutation = useLogout(() => {
    // Clear local storage/async storage
    // This would clear the auth token
    return {};
  });
  const passwordResetMutation = useRequestPasswordReset();
  const resetPasswordMutation = useResetPassword();

  // Initialize auth state
  useEffect(() => {
    const initializeAuth = async () => {
      try {
        const token = await AsyncStorage.getItem('accessToken');
        console.log('Existing token found:', !!token);
      } catch (error) {
        console.error('Error initializing auth:', error);
      } finally {
        setIsInitialized(true);
      }
    };

    initializeAuth();
  }, []);

  // Handle user errors (token expired, etc.)
  useEffect(() => {
    if (userError && isInitialized) {
      console.log('User query error:', userError.message);
      // Don't show error for 401 (just means not authenticated)
      if (!userError.message.includes('401') && !userError.message.includes('Unauthorized')) {
        setAuthError('Unable to verify your session. Please try logging in again.');
      }
    }
  }, [userError, isInitialized]);

  const clearError = () => {
    setAuthError(null);
  };

  const login = async (credentials: LoginRequest) => {
    try {
      clearError();
      await loginMutation.mutateAsync(credentials);
      console.log('Login successful');
    } catch (error: any) {
      const errorMessage = error.message || 'Login failed. Please try again.';
      setAuthError(errorMessage);
      throw error;
    }
  };

  const register = async (userData: RegisterRequest) => {
    try {
      clearError();
      await registerMutation.mutateAsync(userData);
      console.log('Registration successful');
    } catch (error: any) {
      const errorMessage = error.message || 'Registration failed. Please try again.';
      setAuthError(errorMessage);
      throw error;
    }
  };

  const logout = async () => {
    try {
      await logoutMutation.mutateAsync();
      console.log('Logout successful');
    } catch (error: any) {
      console.error('Logout error:', error);
      await AsyncStorage.removeItem('accessToken');
    }
  };

  const requestPasswordReset = async (email: string) => {
    try {
      clearError();
      await passwordResetMutation.mutateAsync(email);
      Alert.alert(
        'Reset Email Sent',
        "If an account with that email exists, we've sent you a password reset link.",
        [{ text: 'OK' }],
      );
    } catch (error: any) {
      const errorMessage = error.message || 'Failed to send reset email. Please try again.';
      setAuthError(errorMessage);
      throw error;
    }
  };

  const resetPassword = async (token: string, newPassword: string) => {
    try {
      clearError();
      await resetPasswordMutation.mutateAsync({ token, newPassword });
      Alert.alert(
        'Password Reset Successful',
        'Your password has been reset. You can now log in with your new password.',
        [{ text: 'OK' }],
      );
    } catch (error: any) {
      const errorMessage = error.message || 'Failed to reset password. Please try again.';
      setAuthError(errorMessage);
      throw error;
    }
  };

  const isAuthenticated = !!user && !userError;
  const isLoading = !isInitialized || userLoading;

  const value: AuthContextType = {
    // User state
    user,
    isAuthenticated,
    isLoading,

    // Auth actions
    login,
    register,
    logout,
    requestPasswordReset,
    resetPassword,

    // Loading states
    isLoginLoading: loginMutation.isPending,
    isRegisterLoading: registerMutation.isPending,
    isPasswordResetLoading: passwordResetMutation.isPending || resetPasswordMutation.isPending,

    // Error states
    authError,
    clearError,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
