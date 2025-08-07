import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useWebAuth } from '../../context/AuthContext';
import { Eye, EyeOff, Mail, Clock, User, Film } from 'lucide-react';
import { Button } from '@repo/components';

interface AuthFormProps {
  mode: 'login' | 'register' | 'forgot-password' | 'reset-password';
  resetToken?: string;
}

const AuthForm: React.FC<AuthFormProps> = ({ mode, resetToken }) => {
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
  } = useWebAuth();

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

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
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
      router.push('/');
    } catch (error) {
      // Error is handled by the auth provider
      console.error('Login error:', error);
    }
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
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
        firstName: firstName || undefined,
        lastName: lastName || undefined,
      });
      router.push('/');
    } catch (error) {
      // Error is handled by the auth provider
      console.error('Register error:', error);
    }
  };

  const handleForgotPassword = async (e: React.FormEvent) => {
    e.preventDefault();
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
      router.push('/auth/login');
    } catch (error) {
      // Error is handled by the auth provider
      console.error('Password reset request error:', error);
    }
  };

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
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
      router.push('/auth/login');
    } catch (error) {
      // Error is handled by the auth provider
      console.error('Password reset error:', error);
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
    <div className="min-h-screen flex items-center justify-center bg-gray-950 px-4 py-12 sm:px-6 lg:px-8">
      {/* Background Pattern */}
      <div className="absolute inset-0 bg-gray-950">
        <div
          className="absolute inset-0 opacity-10"
          style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Cpath d='m36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
          }}
        />
      </div>

      <div className="max-w-md w-full space-y-8 relative z-10">
        <div>
          <div className="flex justify-center">
            <div className="flex items-center space-x-2">
              <Film className="h-8 w-8 text-purple-500" />
              <h1 className="text-2xl font-bold text-white">Movie Diary</h1>
            </div>
          </div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-white">{getTitle()}</h2>
        </div>

        <form className="mt-8 space-y-6" onSubmit={getSubmitHandler()}>
          <div className="bg-gray-900 p-8 rounded-lg shadow-2xl border border-gray-800">
            {/* Error Message */}
            {currentError && (
              <div className="mb-6 p-4 bg-red-500/20 border border-red-500 rounded-lg">
                <p className="text-red-400 text-sm text-center">{currentError}</p>
              </div>
            )}

            <div className="space-y-4">
              {/* Email Field */}
              {(mode === 'login' || mode === 'register' || mode === 'forgot-password') && (
                <div className="relative">
                  <label htmlFor="email" className="sr-only">
                    Email address
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <Mail className="h-5 w-5 text-gray-400" />
                    </div>
                    <input
                      id="email"
                      name="email"
                      type="email"
                      autoComplete="email"
                      required
                      className="relative block w-full pl-10 pr-3 py-3 border border-gray-700 placeholder-gray-400 text-white bg-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 focus:z-10 sm:text-sm"
                      placeholder="Email address"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                    />
                  </div>
                </div>
              )}

              {/* Username Field (Register only) */}
              {mode === 'register' && (
                <div className="relative">
                  <label htmlFor="username" className="sr-only">
                    Username
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <User className="h-5 w-5 text-gray-400" />
                    </div>
                    <input
                      id="username"
                      name="username"
                      type="text"
                      autoComplete="username"
                      required
                      className="relative block w-full pl-10 pr-3 py-3 border border-gray-700 placeholder-gray-400 text-white bg-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 focus:z-10 sm:text-sm"
                      placeholder="Username"
                      value={username}
                      onChange={(e) => setUsername(e.target.value)}
                    />
                  </div>
                </div>
              )}

              {/* Name Fields (Register only) */}
              {mode === 'register' && (
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label htmlFor="firstName" className="sr-only">
                      First Name
                    </label>
                    <input
                      id="firstName"
                      name="firstName"
                      type="text"
                      autoComplete="given-name"
                      className="relative block w-full px-3 py-3 border border-gray-700 placeholder-gray-400 text-white bg-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 focus:z-10 sm:text-sm"
                      placeholder="First Name (Optional)"
                      value={firstName}
                      onChange={(e) => setFirstName(e.target.value)}
                    />
                  </div>
                  <div>
                    <label htmlFor="lastName" className="sr-only">
                      Last Name
                    </label>
                    <input
                      id="lastName"
                      name="lastName"
                      type="text"
                      autoComplete="family-name"
                      className="relative block w-full px-3 py-3 border border-gray-700 placeholder-gray-400 text-white bg-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 focus:z-10 sm:text-sm"
                      placeholder="Last Name (Optional)"
                      value={lastName}
                      onChange={(e) => setLastName(e.target.value)}
                    />
                  </div>
                </div>
              )}

              {/* Password Field */}
              {(mode === 'login' || mode === 'register' || mode === 'reset-password') && (
                <div className="relative">
                  <label htmlFor="password" className="sr-only">
                    Password
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <Clock className="h-5 w-5 text-gray-400" />
                    </div>
                    <input
                      id="password"
                      name="password"
                      type={showPassword ? 'text' : 'password'}
                      autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
                      required
                      className="relative block w-full pl-10 pr-12 py-3 border border-gray-700 placeholder-gray-400 text-white bg-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 focus:z-10 sm:text-sm"
                      placeholder="Password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                    />
                    <div className="absolute inset-y-0 right-0 pr-3 flex items-center">
                      <button
                        type="button"
                        className="text-gray-400 hover:text-gray-300 focus:outline-none focus:text-gray-300"
                        onClick={() => setShowPassword(!showPassword)}
                      >
                        {showPassword ? (
                          <EyeOff className="h-5 w-5" />
                        ) : (
                          <Eye className="h-5 w-5" />
                        )}
                      </button>
                    </div>
                  </div>
                </div>
              )}

              {/* Confirm Password Field */}
              {(mode === 'register' || mode === 'reset-password') && (
                <div className="relative">
                  <label htmlFor="confirmPassword" className="sr-only">
                    Confirm Password
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <Clock className="h-5 w-5 text-gray-400" />
                    </div>
                    <input
                      id="confirmPassword"
                      name="confirmPassword"
                      type={showConfirmPassword ? 'text' : 'password'}
                      autoComplete="new-password"
                      required
                      className="relative block w-full pl-10 pr-12 py-3 border border-gray-700 placeholder-gray-400 text-white bg-gray-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 focus:z-10 sm:text-sm"
                      placeholder="Confirm Password"
                      value={confirmPassword}
                      onChange={(e) => setConfirmPassword(e.target.value)}
                    />
                    <div className="absolute inset-y-0 right-0 pr-3 flex items-center">
                      <button
                        type="button"
                        className="text-gray-400 hover:text-gray-300 focus:outline-none focus:text-gray-300"
                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      >
                        {showConfirmPassword ? (
                          <EyeOff className="h-5 w-5" />
                        ) : (
                          <Eye className="h-5 w-5" />
                        )}
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Submit Button */}
            <div className="mt-6">
              <Button
                type="submit"
                disabled={isLoading}
                className="w-full py-3 px-4 text-sm font-medium bg-purple-600 hover:bg-purple-700 focus:ring-2 focus:ring-offset-2 focus:ring-purple-500"
              >
                {isLoading ? (
                  <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                ) : (
                  getSubmitText()
                )}
              </Button>
            </div>

            {/* Navigation Links */}
            <div className="mt-6 text-center space-y-2">
              {mode === 'login' && (
                <>
                  <div>
                    <Link
                      href="/auth/forgot-password"
                      className="text-purple-400 hover:text-purple-300 text-sm transition-colors duration-200"
                    >
                      Forgot your password?
                    </Link>
                  </div>
                  <div>
                    <span className="text-gray-400 text-sm">Don't have an account? </span>
                    <Link
                      to="/auth/register"
                      className="text-purple-400 hover:text-purple-300 text-sm transition-colors duration-200"
                    >
                      Sign up
                    </Link>
                  </div>
                </>
              )}

              {mode === 'register' && (
                <div>
                  <span className="text-gray-400 text-sm">Already have an account? </span>
                  <Link
                    to="/auth/login"
                    className="text-purple-400 hover:text-purple-300 text-sm transition-colors duration-200"
                  >
                    Sign in
                  </Link>
                </div>
              )}

              {mode === 'forgot-password' && (
                <div>
                  <Link
                    to="/auth/login"
                    className="text-purple-400 hover:text-purple-300 text-sm transition-colors duration-200"
                  >
                    Back to sign in
                  </Link>
                </div>
              )}
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AuthForm;
