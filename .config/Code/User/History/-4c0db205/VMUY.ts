import { z } from 'zod';

export const registerSchema = z.object({
  email: z.email('Invalid email format'),
  firstName: z.string().min(1, 'First name is required').max(100),
  lastName: z.string().min(1, 'Last name is required').max(100),
  role: z.enum(['user', 'agent']).optional().default('user'),
});

export const loginSchema = z.object({
  email: z.email('Invalid email format'),
});

export const verifyOTPSchema = z.object({
  otp: z.string().length(6, 'OTP must be exactly 6 digits').regex(/^\d{6}$/, 'OTP must contain only numbers'),
  token: z.string().min(1, 'Token is required'),
});

export const requestLoginOTPSchema = z.object({
  email: z.email('Invalid email format'),
});

export const forgotPasswordSchema = z.object({
  email: z.email('Invalid email format'),
});

export const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
});

export const resendVerificationSchema = z.object({
  email: z.email('Invalid email format'),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type VerifyOTPInput = z.infer<typeof verifyOTPSchema>;
export type RequestLoginOTPInput = z.infer<typeof requestLoginOTPSchema>;
export type ForgotPasswordInput = z.infer<typeof forgotPasswordSchema>;
export type ResetPasswordInput = z.infer<typeof resetPasswordSchema>;
export type ResendVerificationInput = z.infer<typeof resendVerificationSchema>;
