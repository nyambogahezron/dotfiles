import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  StyleSheet,
} from 'react-native';
import { useServerAuth } from '@/components/auth/AuthProvider';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import Colors from '@/constants/Colors';

interface ServerAuthFormProps {
  mode: 'login' | 'register' | 'forgot-password' | 'reset-password';
  resetToken?: string;
}

export default function ServerAuthForm({ mode, resetToken }: ServerAuthFormProps) {
  const {
    login,
    register,
    requestPasswordReset,
    resetPassword,
    isLoginLoading,
    isRegisterLoading,
    isPasswordResetLoading,
    authError,
    clearError,
  } = useServerAuth();

  const router = useRouter();

  // Form state
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [username, setUsername] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [localError, setLocalError] = useState('');

  const clearErrors = () => {
    setLocalError('');
    clearError();
  };

  const validateEmail = (email: string) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const validatePassword = (password: string) => {
    return password.length >= 6;
  };

  const handleLogin = async () => {
    clearErrors();

    if (!email || !password) {
      setLocalError('Please enter both email and password');
      return;
    }

    if (!validateEmail(email)) {
      setLocalError('Please enter a valid email address');
      return;
    }

    try {
      await login({ email, password });
      router.replace('/(tabs)');
    } catch (error) {
      // Error is handled by the auth provider
    }
  };

  const handleRegister = async () => {
    clearErrors();

    if (!email || !password || !username) {
      setLocalError('Please fill in all required fields');
      return;
    }

    if (!validateEmail(email)) {
      setLocalError('Please enter a valid email address');
      return;
    }

    if (!validatePassword(password)) {
      setLocalError('Password must be at least 6 characters');
      return;
    }

    if (password !== confirmPassword) {
      setLocalError('Passwords do not match');
      return;
    }

    try {
      await register({
        email,
        password,
        username,
      });
      router.replace('/(tabs)');
    } catch (error) {
      // Error is handled by the auth provider
    }
  };

  const handleForgotPassword = async () => {
    clearErrors();

    if (!email) {
      setLocalError('Please enter your email address');
      return;
    }

    if (!validateEmail(email)) {
      setLocalError('Please enter a valid email address');
      return;
    }

    try {
      await requestPasswordReset(email);
      router.back();
    } catch (error) {
      // Error is handled by the auth provider
    }
  };

  const handleResetPassword = async () => {
    clearErrors();

    if (!password || !confirmPassword) {
      setLocalError('Please fill in both password fields');
      return;
    }

    if (!validatePassword(password)) {
      setLocalError('Password must be at least 6 characters');
      return;
    }

    if (password !== confirmPassword) {
      setLocalError('Passwords do not match');
      return;
    }

    if (!resetToken) {
      setLocalError('Invalid reset token');
      return;
    }

    try {
      await resetPassword(resetToken, password);
      router.replace('/(auth)/login' as any);
    } catch (error) {
      // Error is handled by the auth provider
    }
  };

  const getSubmitHandler = () => {
    switch (mode) {
      case 'login':
        return handleLogin;
      case 'register':
        return handleRegister;
      case 'forgot-password':
        return handleForgotPassword;
      case 'reset-password':
        return handleResetPassword;
      default:
        return handleLogin;
    }
  };

  const getSubmitText = () => {
    switch (mode) {
      case 'login':
        return 'Sign In';
      case 'register':
        return 'Create Account';
      case 'forgot-password':
        return 'Send Reset Email';
      case 'reset-password':
        return 'Reset Password';
      default:
        return 'Submit';
    }
  };

  const getTitle = () => {
    switch (mode) {
      case 'login':
        return 'Welcome Back';
      case 'register':
        return 'Create Account';
      case 'forgot-password':
        return 'Reset Password';
      case 'reset-password':
        return 'New Password';
      default:
        return 'Authentication';
    }
  };

  const isLoading = isLoginLoading || isRegisterLoading || isPasswordResetLoading;
  const currentError = localError || authError;

  return (
    <View style={styles.container}>
      <View style={styles.form}>
        <Text style={styles.title}>{getTitle()}</Text>

        {currentError ? (
          <View style={styles.errorContainer}>
            <Text style={styles.errorText}>{currentError}</Text>
          </View>
        ) : null}

        {/* Email Field */}
        {(mode === 'login' || mode === 'register' || mode === 'forgot-password') && (
          <View style={styles.inputContainer}>
            <Ionicons name="mail" size={20} color={Colors.neutral[400]} style={styles.inputIcon} />
            <TextInput
              style={styles.input}
              placeholder="Email"
              placeholderTextColor={Colors.neutral[400]}
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
            />
          </View>
        )}

        {/* Username Field (Register only) */}
        {mode === 'register' && (
          <View style={styles.inputContainer}>
            <Ionicons
              name="person"
              size={20}
              color={Colors.neutral[400]}
              style={styles.inputIcon}
            />
            <TextInput
              style={styles.input}
              placeholder="Username"
              placeholderTextColor={Colors.neutral[400]}
              value={username}
              onChangeText={setUsername}
              autoCapitalize="none"
              autoCorrect={false}
            />
          </View>
        )}

        {/* Name Fields (Register only) */}
        {mode === 'register' && (
          <View style={styles.row}>
            <View style={[styles.inputContainer, styles.halfWidth]}>
              <TextInput
                style={styles.input}
                placeholder="First Name"
                placeholderTextColor={Colors.neutral[400]}
                value={firstName}
                onChangeText={setFirstName}
                autoCapitalize="words"
              />
            </View>
            <View style={[styles.inputContainer, styles.halfWidth]}>
              <TextInput
                style={styles.input}
                placeholder="Last Name"
                placeholderTextColor={Colors.neutral[400]}
                value={lastName}
                onChangeText={setLastName}
                autoCapitalize="words"
              />
            </View>
          </View>
        )}

        {/* Password Field */}
        {(mode === 'login' || mode === 'register' || mode === 'reset-password') && (
          <View style={styles.inputContainer}>
            <Ionicons
              name="lock-closed"
              size={20}
              color={Colors.neutral[400]}
              style={styles.inputIcon}
            />
            <TextInput
              style={[styles.input, styles.passwordInput]}
              placeholder="Password"
              placeholderTextColor={Colors.neutral[400]}
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
              autoCapitalize="none"
              autoCorrect={false}
            />
            <TouchableOpacity style={styles.eyeIcon} onPress={() => setShowPassword(!showPassword)}>
              {showPassword ? (
                <Ionicons name="eye-off" size={20} color={Colors.neutral[400]} />
              ) : (
                <Ionicons name="eye" size={20} color={Colors.neutral[400]} />
              )}
            </TouchableOpacity>
          </View>
        )}

        {/* Confirm Password Field */}
        {(mode === 'register' || mode === 'reset-password') && (
          <View style={styles.inputContainer}>
            <Ionicons
              name="lock-closed"
              size={20}
              color={Colors.neutral[400]}
              style={styles.inputIcon}
            />
            <TextInput
              style={[styles.input, styles.passwordInput]}
              placeholder="Confirm Password"
              placeholderTextColor={Colors.neutral[400]}
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              secureTextEntry={!showConfirmPassword}
              autoCapitalize="none"
              autoCorrect={false}
            />
            <TouchableOpacity
              style={styles.eyeIcon}
              onPress={() => setShowConfirmPassword(!showConfirmPassword)}
            >
              {showConfirmPassword ? (
                <Ionicons name="eye-off" size={20} color={Colors.neutral[400]} />
              ) : (
                <Ionicons name="eye" size={20} color={Colors.neutral[400]} />
              )}
            </TouchableOpacity>
          </View>
        )}

        {/* Submit Button */}
        <TouchableOpacity
          style={[styles.submitButton, isLoading && styles.submitButtonDisabled]}
          onPress={getSubmitHandler()}
          disabled={isLoading}
        >
          {isLoading ? (
            <ActivityIndicator size="small" color={Colors.neutral[50]} />
          ) : (
            <Text style={styles.submitButtonText}>{getSubmitText()}</Text>
          )}
        </TouchableOpacity>

        {/* Navigation Links */}
        <View style={styles.linksContainer}>
          {mode === 'login' && (
            <>
              <TouchableOpacity onPress={() => router.push('/(auth)/forgot-password' as any)}>
                <Text style={styles.linkText}>Forgot Password?</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={() => router.push('/(auth)/register' as any)}>
                <Text style={styles.linkText}>Don't have an account? Sign Up</Text>
              </TouchableOpacity>
            </>
          )}

          {mode === 'register' && (
            <TouchableOpacity onPress={() => router.push('/(auth)/login' as any)}>
              <Text style={styles.linkText}>Already have an account? Sign In</Text>
            </TouchableOpacity>
          )}

          {mode === 'forgot-password' && (
            <TouchableOpacity onPress={() => router.push('/(auth)/login' as any)}>
              <Text style={styles.linkText}>Back to Sign In</Text>
            </TouchableOpacity>
          )}
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    paddingVertical: 24,
  },
  form: {
    padding: 24,
  },
  title: {
    fontSize: 28,
    fontFamily: 'Inter-Bold',
    color: Colors.neutral[50],
    textAlign: 'center',
    marginBottom: 32,
  },
  errorContainer: {
    backgroundColor: Colors.error[500] + '20',
    borderWidth: 1,
    borderColor: Colors.error[500],
    borderRadius: 8,
    padding: 12,
    marginBottom: 16,
  },
  errorText: {
    color: Colors.error[500],
    fontSize: 14,
    fontFamily: 'Inter-Medium',
    textAlign: 'center',
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.neutral[800],
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 8,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: Colors.neutral[700],
  },
  inputIcon: {
    marginRight: 12,
  },
  input: {
    flex: 1,
    fontSize: 16,
    fontFamily: 'Inter-Regular',
    color: Colors.neutral[50],
  },
  passwordInput: {
    paddingRight: 40,
  },
  eyeIcon: {
    position: 'absolute',
    right: 16,
    padding: 4,
  },
  row: {
    flexDirection: 'row',
    gap: 12,
  },
  halfWidth: {
    flex: 1,
  },
  submitButton: {
    backgroundColor: Colors.primary[500],
    borderRadius: 12,
    paddingVertical: 16,
    alignItems: 'center',
    marginTop: 8,
    marginBottom: 24,
  },
  submitButtonDisabled: {
    opacity: 0.6,
  },
  submitButtonText: {
    fontSize: 16,
    fontFamily: 'Inter-Bold',
    color: Colors.neutral[50],
  },
  linksContainer: {
    alignItems: 'center',
    gap: 12,
  },
  linkText: {
    fontSize: 14,
    fontFamily: 'Inter-Medium',
    color: Colors.primary[500],
    textAlign: 'center',
  },
});
