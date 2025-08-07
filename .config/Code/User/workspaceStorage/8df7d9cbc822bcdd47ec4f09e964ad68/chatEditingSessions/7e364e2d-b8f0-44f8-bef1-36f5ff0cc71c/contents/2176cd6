import { Request, Response } from 'express';
import { formatResponse } from '../utils/helpers';
import {
  LoginInput,
  RegisterInput,
  ResendVerificationInput,
  VerifyOTPInput,
  RequestLoginOTPInput,
} from '../validations/auth.validation';
import AsyncHandler from '../middleware/asyncHandler';
import {
  BadRequestError,
  NotFoundError,
  UnauthorizedError,
} from '../utils/errors';
import { StatusCodes } from 'http-status-codes';
import { UserServices } from '../services/user.services';
import Token from '../utils/signedTokens';
import { User } from '../interfaces/index.d';
import { EmailService } from '../services/email.service';
import { db } from '../database/connection';
import { tokens } from '../database/schema/tokens';
import { users } from '../database/schema/users';
import { eq, and } from 'drizzle-orm';
import { OTPService } from '../utils/otp';
import crypto from 'crypto';

interface AuthRequest extends Request {
  user?: User;
}

export const register = AsyncHandler(async (req: Request, res: Response) => {
  const { email, firstName, lastName, role } = req.body as RegisterInput;

  const allowedRoles = ['admin', 'user', 'agent'];
  if (!allowedRoles.includes(role)) {
    throw new BadRequestError('Invalid role specified');
  }

  const existingUser = await UserServices.findUserByEmail(email);

  if (existingUser) {
    throw new BadRequestError('User with this email already exists');
  }

  const newUser = await UserServices.insertUser({
    email,
    firstName,
    lastName,
    role,
  });

  // Generate OTP for email verification
  const { otp, signedToken } = OTPService.generateOTP(newUser.id.toString(), 'email_verification');
  const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes expiry

  // Store verification token in database with hashed OTP
  await db.insert(tokens).values({
    userId: newUser.id,
    token: signedToken,
    type: 'email_verification',
    expiresAt,
  });

  // Send verification email with OTP
  await EmailService.sendVerificationOTPEmail({
    email,
    name: firstName,
    otp,
  });

  res
    .status(StatusCodes.CREATED)
    .json(
      formatResponse(
        { user: { ...newUser, emailVerified: false }, verificationToken: signedToken },
        'User registered successfully. Please check your email for the verification code.'
      )
    );
});

export const login = AsyncHandler(async (req: Request, res: Response) => {
  const { email } = req.body as LoginInput;

  const user = await UserServices.findUserByEmail(email);

  if (!user) {
    // For security, don't reveal if user exists
    res.json(
      formatResponse(
        null,
        'If the email exists and is verified, a login code has been sent.'
      )
    );
    return;
  }

  if (!user.isActive) {
    throw new BadRequestError('Account is deactivated');
  }

  if (!user.emailVerified) {
    throw new BadRequestError(
      'Please verify your email address before logging in'
    );
  }

  // Generate OTP for login
  const { otp, signedToken } = OTPService.generateOTP(user.id.toString(), 'login');
  const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes expiry

  // Delete any existing login tokens for this user
  await db
    .delete(tokens)
    .where(
      and(eq(tokens.userId, user.id), eq(tokens.type, 'login'))
    );

  // Store login token in database
  await db.insert(tokens).values({
    userId: user.id,
    token: signedToken,
    type: 'login',
    expiresAt,
  });

  // Send login OTP email
  await EmailService.sendLoginOTPEmail({
    email: user.email,
    name: user.firstName || user.email,
    otp,
  });

  res.json(
    formatResponse(
      { loginToken: signedToken },
      'Login code sent to your email address.'
    )
  );
});

export const logout = AsyncHandler(async (req: Request, res: Response) => {
  res.clearCookie('accessToken');
  res.clearCookie('refreshToken');
  res.clearCookie('verificationToken');

  res.json(formatResponse(null, 'Logout successful'));
});

export const me = AsyncHandler(async (req: AuthRequest, res: Response) => {
  if (!req.user) {
    throw new UnauthorizedError('User not authenticated');
  }

  const user = await UserServices.findUserById(req.user.id.toString());
  if (!user) {
    throw new NotFoundError('User not found');
  }

  res.json(formatResponse(user, 'User profile retrieved successfully'));
});

export const verifyOTP = AsyncHandler(async (req: Request, res: Response) => {
  const { otp, token } = req.body as VerifyOTPInput;

  if (!otp || !token) {
    throw new BadRequestError('OTP and token are required');
  }

  // Find the token in database
  const tokenRecord = await db
    .select()
    .from(tokens)
    .where(eq(tokens.token, token))
    .then((r) => r[0]);

  if (!tokenRecord || tokenRecord.expiresAt < new Date()) {
    throw new BadRequestError('Invalid or expired token');
  }

  // Verify OTP against the signed token
  const verification = OTPService.verifyOTP(otp, token, tokenRecord.type as 'email_verification' | 'login');
  
  if (!verification.isValid) {
    throw new BadRequestError(verification.error || 'Invalid OTP');
  }

  // Find the user
  const user = await db
    .select()
    .from(users)
    .where(eq(users.id, tokenRecord.userId))
    .then((r) => r[0]);

  if (!user) {
    throw new NotFoundError('User not found');
  }

  // Handle different token types
  if (tokenRecord.type === 'email_verification') {
    if (user.emailVerified) {
      // Remove the verification token
      await db.delete(tokens).where(eq(tokens.id, tokenRecord.id));
      
      // Issue session tokens for already verified user
      const { accessToken } = await Token.attachTokenToRequest(user.id, res);

      res.json(
        formatResponse(
          { user: { ...user, accessToken } },
          'Email already verified. You are now logged in.'
        )
      );
      return;
    }

    // Mark user as verified
    await db
      .update(users)
      .set({ emailVerified: true })
      .where(eq(users.id, user.id));

    // Send welcome email
    await EmailService.sendWelcomeEmail({
      id: Number(user.id),
      email: user.email,
      name: user.firstName || user.email,
      username: user.firstName || user.email,
    });

    // Remove the verification token
    await db.delete(tokens).where(eq(tokens.id, tokenRecord.id));

    // Issue session tokens
    const { accessToken } = await Token.attachTokenToRequest(user.id, res);

    res.json(
      formatResponse(
        { user: { ...user, emailVerified: true, accessToken } },
        'Email verified successfully! Welcome to Task Flow.'
      )
    );
  } else if (tokenRecord.type === 'login') {
    // Update last login
    await UserServices.updateLastLogin(Number(user.id));

    // Remove the login token
    await db.delete(tokens).where(eq(tokens.id, tokenRecord.id));

    // Issue session tokens
    const { accessToken } = await Token.attachTokenToRequest(user.id, res);

    res.json(
      formatResponse(
        { user: { ...user, accessToken } },
        'Login successful'
      )
    );
  } else {
    throw new BadRequestError('Invalid token type');
  }
});

export const resendVerificationEmail = AsyncHandler(
  async (req: Request, res: Response) => {
    const { email } = req.body as ResendVerificationInput;

    if (!email) {
      throw new BadRequestError('Email is required');
    }

    const user = await UserServices.findUserByEmail(email);

    if (!user) {
      // For security, don't reveal if user exists
      res.json(
        formatResponse(
          null,
          'If the email exists and is not verified, a verification code has been sent.'
        )
      );
      return;
    }

    if (user.emailVerified) {
      throw new BadRequestError('Email is already verified');
    }

    // Delete any existing verification tokens for this user
    await db
      .delete(tokens)
      .where(
        and(eq(tokens.userId, user.id), eq(tokens.type, 'email_verification'))
      );

    // Generate new verification OTP
    const { otp, signedToken } = OTPService.generateOTP(user.id.toString(), 'email_verification');
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes expiry

    // Store new verification token in database
    await db.insert(tokens).values({
      userId: user.id,
      token: signedToken,
      type: 'email_verification',
      expiresAt,
    });

    // Send verification email with OTP
    await EmailService.sendVerificationOTPEmail({
      email: user.email,
      name: user.firstName,
      otp,
    });

    res.json(
      formatResponse(
        { verificationToken: signedToken },
        'If the email exists and is not verified, a verification code has been sent.'
      )
    );
  }
);

export const requestLoginOTP = AsyncHandler(
  async (req: Request, res: Response) => {
    const { email } = req.body as RequestLoginOTPInput;
    
    if (!email) {
      throw new BadRequestError('Email is required');
    }
    
    const user = await db
      .select()
      .from(users)
      .where(eq(users.email, email))
      .then((r) => r[0]);
      
    if (!user || !user.isActive) {
      // For security, do not reveal if user exists
      res.json(
        formatResponse(null, 'If the email exists, a login code has been sent.')
      );
      return;
    }

    if (!user.emailVerified) {
      throw new BadRequestError('Please verify your email address first');
    }
    
    // Delete any existing login tokens for this user
    await db
      .delete(tokens)
      .where(
        and(eq(tokens.userId, user.id), eq(tokens.type, 'login'))
      );
    
    // Generate OTP for login
    const { otp, signedToken } = OTPService.generateOTP(user.id.toString(), 'login');
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes expiry
    
    await db.insert(tokens).values({
      userId: user.id,
      token: signedToken,
      type: 'login',
      expiresAt,
    });
    
    await EmailService.sendLoginOTPEmail({
      email: user.email,
      name: user.firstName || user.email,
      otp,
    });
    
    res.json(
      formatResponse(
        { loginToken: signedToken },
        'If the email exists, a login code has been sent.'
      )
    );
  }
);
