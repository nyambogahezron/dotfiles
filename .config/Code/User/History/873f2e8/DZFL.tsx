import React, { createContext, useContext, useState } from 'react';
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
    return {};
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
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'Login failed';
      setAuthError(errorMessage);
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
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'Registration failed';
      setAuthError(errorMessage);
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
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'Password reset request failed';
      setAuthError(errorMessage);
      throw error;
    }
  };

  const resetPassword = async (token: string, newPassword: string) => {
    try {
      setAuthError(null);
      await passwordResetMutation.mutateAsync({ token, newPassword });
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'Password reset failed';
      setAuthError(errorMessage);
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
