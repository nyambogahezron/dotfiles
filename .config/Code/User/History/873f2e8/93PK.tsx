import React, { createContext, useContext, useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  useLogin,
  useRegister,
  useCurrentUser,
  useRequestPasswordReset,
  useResetPassword,
  useLogout,
} from '@repo/services';
import type { ServerUser, LoginRequest, RegisterRequest } from '@repo/services';
import { getStorageAdapter } from '@repo/utils';

const storage = getStorageAdapter();

interface AuthContextType {
  user: ServerUser | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (credentials: LoginRequest) => Promise<void>;
  register: (userData: RegisterRequest) => Promise<void>;
  logout: () => Promise<void>;
  requestPasswordReset: (email: string) => Promise<void>;
  resetPassword: (token: string, newPassword: string) => Promise<void>;
  authError: string | null;
  clearError: () => void;
  isLoginLoading: boolean;
  isRegisterLoading: boolean;
  isPasswordResetLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  useLogin,
  useRegister,
  useCurrentUser,
  useRequestPasswordReset,
  useResetPassword,
  useLogout,
} from '@repo/services';
import type { ServerUser, LoginRequest, RegisterRequest } from '@repo/services';
import { getStorageAdapter } from '@repo/utils';

const storage = getStorageAdapter();

interface AuthContextType {
  user: ServerUser | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (credentials: LoginRequest) => Promise<void>;
  register: (userData: RegisterRequest) => Promise<void>;
  logout: () => Promise<void>;
  requestPasswordReset: (email: string) => Promise<void>;
  resetPassword: (token: string, newPassword: string) => Promise<void>;
  authError: string | null;
  clearError: () => void;
  isLoginLoading: boolean;
  isRegisterLoading: boolean;
  isPasswordResetLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useWebAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useWebAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: React.ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [authError, setAuthError] = useState<string | null>(null);

  // Use the query hooks
  const { data: user, isLoading: isUserLoading } = useCurrentUser();
  const loginMutation = useLogin();
  const registerMutation = useRegister();
  const passwordResetRequestMutation = useRequestPasswordReset();
  const passwordResetMutation = useResetPassword();
  const logoutMutation = useLogout(() => {
    // Clear storage on logout
    storage.removeItem('authToken');
    storage.removeItem('refreshToken');
  });

  const clearError = () => setAuthError(null);

  const login = async (credentials: LoginRequest) => {
    try {
      setAuthError(null);
      const result = await loginMutation.mutateAsync(credentials);
      // Store tokens if they're in the result
      if (result?.accessToken) {
        await storage.setItem('authToken', result.accessToken);
      }
      if (result?.refreshToken) {
        await storage.setItem('refreshToken', result.refreshToken);
      }
    } catch (error: any) {
      setAuthError(error?.response?.data?.message || 'Login failed');
      throw error;
    }
  };

  const register = async (userData: RegisterRequest) => {
    try {
      setAuthError(null);
      const result = await registerMutation.mutateAsync(userData);
      // Store tokens if they're in the result
      if (result?.accessToken) {
        await storage.setItem('authToken', result.accessToken);
      }
      if (result?.refreshToken) {
        await storage.setItem('refreshToken', result.refreshToken);
      }
    } catch (error: any) {
      setAuthError(error?.response?.data?.message || 'Registration failed');
      throw error;
    }
  };

  const logout = async () => {
    try {
      await logoutMutation.mutateAsync();
    } catch (error) {
      // Even if logout fails on server, clear local storage
      console.error('Logout error:', error);
    } finally {
      await storage.removeItem('authToken');
      await storage.removeItem('refreshToken');
    }
  };

  const requestPasswordReset = async (email: string) => {
    try {
      setAuthError(null);
      await passwordResetRequestMutation.mutateAsync(email);
    } catch (error: any) {
      setAuthError(error?.response?.data?.message || 'Password reset request failed');
      throw error;
    }
  };

  const resetPassword = async (token: string, newPassword: string) => {
    try {
      setAuthError(null);
      await passwordResetMutation.mutateAsync({ token, newPassword });
    } catch (error: any) {
      setAuthError(error?.response?.data?.message || 'Password reset failed');
      throw error;
    }
  };

  const value: AuthContextType = {
    user: user || null,
    isLoading: isUserLoading,
    isAuthenticated: !!user,
    login,
    register,
    logout,
    requestPasswordReset,
    resetPassword,
    authError,
    clearError,
    isLoginLoading: loginMutation.isPending,
    isRegisterLoading: registerMutation.isPending,
    isPasswordResetLoading:
      passwordResetRequestMutation.isPending || passwordResetMutation.isPending,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

interface WebAuthProviderProps {
  children: React.ReactNode;
}

export const WebAuthProvider: React.FC<WebAuthProviderProps> = ({ children }) => {
  const [authError, setAuthError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  // Check if user is authenticated by trying to get current user
  const {
    data: user,
    isLoading,
    error,
  } = useQuery({
    queryKey: ['auth', 'user'],
    queryFn: AuthService.getCurrentUser,
    retry: false,
    staleTime: 1000 * 60 * 5, // 5 minutes
    gcTime: 1000 * 60 * 30, // 30 minutes
  });

  const isAuthenticated = !!user && !error;

  // Login mutation
  const loginMutation = useMutation({
    mutationFn: AuthService.login,
    onSuccess: (data) => {
      // Store tokens
      storage.setItem('authToken', data.accessToken);
      storage.setItem('refreshToken', data.refreshToken);

      // Update user data in cache
      queryClient.setQueryData(['auth', 'user'], data.user);
      setAuthError(null);
    },
    onError: (error: unknown) => {
      let message = 'Login failed';
      if (
        error &&
        typeof error === 'object' &&
        'response' in error &&
        error.response &&
        typeof error.response === 'object' &&
        'data' in error.response &&
        error.response.data &&
        typeof error.response.data === 'object' &&
        'message' in error.response.data
      ) {
        // @ts-expect-error: dynamic check
        message = error.response.data.message;
      } else if (error && typeof error === 'object' && 'message' in error) {
        // @ts-expect-error: dynamic check
        message = error.message;
      }
      setAuthError(message);
    },
  });

  // Register mutation
  const registerMutation = useMutation({
    mutationFn: AuthService.register,
    onSuccess: (data) => {
      // Store tokens
      storage.setItem('authToken', data.accessToken);
      storage.setItem('refreshToken', data.refreshToken);

      // Update user data in cache
      queryClient.setQueryData(['auth', 'user'], data.user);
      setAuthError(null);
    },
    onError: (error: unknown) => {
      let message = 'Registration failed';
      if (
        error &&
        typeof error === 'object' &&
        'response' in error &&
        error.response &&
        typeof error.response === 'object' &&
        'data' in error.response &&
        error.response.data &&
        typeof error.response.data === 'object' &&
        'message' in error.response.data
      ) {
        // @ts-expect-error: dynamic check
        message = error.response.data.message;
      } else if (error && typeof error === 'object' && 'message' in error) {
        // @ts-expect-error: dynamic check
        message = error.message;
      }
      setAuthError(message);
    },
  });

  // Password reset request mutation
  const passwordResetRequestMutation = useMutation({
    mutationFn: AuthService.requestPasswordReset,
    onSuccess: () => {
      setAuthError(null);
    },
    onError: (error: unknown) => {
      let message = 'Password reset request failed';
      if (
        error &&
        typeof error === 'object' &&
        'response' in error &&
        error.response &&
        typeof error.response === 'object' &&
        'data' in error.response &&
        error.response.data &&
        typeof error.response.data === 'object' &&
        'message' in error.response.data
      ) {
        // @ts-expect-error: dynamic check
        message = error.response.data.message;
      } else if (error && typeof error === 'object' && 'message' in error) {
        // @ts-expect-error: dynamic check
        message = error.message;
      }
      setAuthError(message);
    },
  });

  // Password reset mutation
  const passwordResetMutation = useMutation({
    mutationFn: ({ token, newPassword }: { token: string; newPassword: string }) =>
      AuthService.resetPassword(token, newPassword),
    onSuccess: () => {
      setAuthError(null);
    },
    onError: (error: unknown) => {
      let message = 'Password reset failed';
      if (
        error &&
        typeof error === 'object' &&
        'response' in error &&
        error.response &&
        typeof error.response === 'object' &&
        'data' in error.response &&
        error.response.data &&
        typeof error.response.data === 'object' &&
        'message' in error.response.data
      ) {
        // @ts-expect-error: dynamic check
        message = error.response.data.message;
      } else if (error && typeof error === 'object' && 'message' in error) {
        // @ts-expect-error: dynamic check
        message = error.message;
      }
      setAuthError(message);
    },
  });

  // Logout function
  const logout = async () => {
    try {
      // Clear tokens
      storage.removeItem('authToken');
      storage.removeItem('refreshToken');

      // Clear all cached data
      queryClient.clear();

      // Redirect to login page
      window.location.href = '/auth/login';
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  // Clear error function
  const clearError = () => {
    setAuthError(null);
  };

  // Helper functions
  const login = async (credentials: LoginRequest) => {
    await loginMutation.mutateAsync(credentials);
  };

  const register = async (userData: RegisterRequest) => {
    await registerMutation.mutateAsync(userData);
  };

  const requestPasswordReset = async (email: string) => {
    await passwordResetRequestMutation.mutateAsync(email);
  };

  const resetPassword = async (token: string, newPassword: string) => {
    await passwordResetMutation.mutateAsync({ token, newPassword });
  };

  const value: AuthContextType = {
    user: user || null,
    isLoading,
    isAuthenticated,
    login,
    register,
    logout,
    requestPasswordReset,
    resetPassword,
    authError,
    clearError,
    isLoginLoading: loginMutation.isPending,
    isRegisterLoading: registerMutation.isPending,
    isPasswordResetLoading:
      passwordResetRequestMutation.isPending || passwordResetMutation.isPending,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
