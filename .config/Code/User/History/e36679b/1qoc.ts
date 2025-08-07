import { Request, Response } from 'express';
import { formatResponse } from '../utils/helpers';
import { LoginInput, RegisterInput, ResendVerificationInput } from '../validations/auth.validation';
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
import { eq } from 'drizzle-orm';
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

  // Generate email verification token
  const verificationToken = crypto.randomBytes(32).toString('hex');
  const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours expiry

  // Store verification token in database
  await db.insert(tokens).values({
    userId: newUser.id,
    token: verificationToken,
    type: 'email_verification',
    expiresAt,
  });

  // Set verification token as HTTP-only cookie
  res.cookie('verificationToken', verificationToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
  });

  // Send verification email
  await EmailService.sendVerificationEmail({
    email,
    name: firstName,
    token: verificationToken,
  });

  res
    .status(StatusCodes.CREATED)
    .json(
      formatResponse(
        { user: { ...newUser, emailVerified: false } },
        'User registered successfully. Please check your email to verify your account.'
      )
    );
});

export const login = AsyncHandler(async (req: Request, res: Response) => {
  const { email } = req.body as LoginInput;

  const user = await UserServices.findUserByEmail(email);

  if (!user.isActive) {
    throw new BadRequestError('Account is deactivated');
  }

  if (!user.emailVerified) {
    throw new BadRequestError(
      'Please verify your email address before logging in'
    );
  }

  await UserServices.updateLastLogin(Number(user.id));

  const { accessToken } = await Token.attachTokenToRequest(user.id, res);

  res.json(formatResponse({ user, accessToken }, 'Login successful'));
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

export const verifyEmail = AsyncHandler(async (req: Request, res: Response) => {
  const { token } = req.query as { token: string };

  if (!token) {
    throw new BadRequestError('Verification token is required');
  }

  // Find the token in database
  const tokenRecord = await db
    .select()
    .from(tokens)
    .where(eq(tokens.token, token))
    .then((r) => r[0]);

  if (
    !tokenRecord ||
    tokenRecord.expiresAt < new Date() ||
    tokenRecord.type !== 'email_verification'
  ) {
    throw new BadRequestError('Invalid or expired verification token');
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

  if (user.emailVerified) {
    // Remove the verification token cookie if user is already verified
    res.clearCookie('verificationToken');

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

  // Remove the verification token from database
  await db.delete(tokens).where(eq(tokens.id, tokenRecord.id));

  // Clear the verification token cookie
  res.clearCookie('verificationToken');

  // Issue session tokens
  const { accessToken } = await Token.attachTokenToRequest(user.id, res);

  // Send welcome email
  await EmailService.sendWelcomeEmail({
    id: Number(user.id),
    email: user.email,
    name: user.firstName || user.email,
    username: user.firstName || user.email,
  });

  res.json(
    formatResponse(
      { user: { ...user, emailVerified: true, accessToken } },
      'Email verified successfully! Welcome to Task Flow.'
    )
  );
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
          'If the email exists and is not verified, a verification email has been sent.'
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
        eq(tokens.userId, user.id) && eq(tokens.type, 'email_verification')
      );

    // Generate new verification token
    const verificationToken = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours expiry

    // Store new verification token in database
    await db.insert(tokens).values({
      userId: user.id,
      token: verificationToken,
      type: 'email_verification',
      expiresAt,
    });

    // Set verification token as HTTP-only cookie
    res.cookie('verificationToken', verificationToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 24 * 60 * 60 * 1000, // 24 hours
    });

    // Send verification email
    await EmailService.sendVerificationEmail({
      email: user.email,
      name: user.firstName,
      token: verificationToken,
    });

    res.json(
      formatResponse(
        null,
        'If the email exists and is not verified, a verification email has been sent.'
      )
    );
  }
);

export const requestVerifyLink = AsyncHandler(
  async (req: Request, res: Response) => {
    const { email, redirectUri } = req.body as {
      email: string;
      redirectUri: string;
    };
    if (!email || !redirectUri) {
      throw new BadRequestError('Email and redirectUri are required');
    }
    const user = await db
      .select()
      .from(users)
      .where(eq(users.email, email))
      .then((r) => r[0]);
    if (!user || !user.isActive) {
      // For security, do not reveal if user exists
      res.json(
        formatResponse(null, 'If the email exists, a magic link has been sent.')
      );
      return;
    }
    // Generate token
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 min expiry
    await db.insert(tokens).values({
      userId: user.id,
      token,
      type: 'magic_link',
      expiresAt,
    });
    await EmailService.sendMagicLinkEmail(
      {
        id: Number(user.id),
        email: user.email,
        name: user.firstName || user.email,
        username: user.firstName || user.email,
      },
      token,
      redirectUri
    );
    res.json(
      formatResponse(null, 'If the email exists, a magic link has been sent.')
    );
    return;
  }
);

export const verifyMagicLink = AsyncHandler(
  async (req: Request, res: Response) => {
    const { token } = req.body as { token: string };
    if (!token) throw new BadRequestError('Token is required');
    const tokenRecord = await db
      .select()
      .from(tokens)
      .where(eq(tokens.token, token))
      .then((r) => r[0]);
    if (
      !tokenRecord ||
      tokenRecord.expiresAt < new Date() ||
      tokenRecord.type !== 'magic_link'
    ) {
      throw new BadRequestError('Invalid or expired token');
    }
    const user = await db
      .select()
      .from(users)
      .where(eq(users.id, tokenRecord.userId))
      .then((r) => r[0]);
    if (!user || !user.isActive) {
      throw new UnauthorizedError('User not found or inactive');
    }
    // Mark user as verified if not already
    if (!user.emailVerified) {
      await db
        .update(users)
        .set({ emailVerified: true })
        .where(eq(users.id, user.id));
    }
    // Remove used token
    await db.delete(tokens).where(eq(tokens.id, tokenRecord.id));
    // Issue session
    const { accessToken } = await Token.attachTokenToRequest(user.id, res);
    res.json(
      formatResponse(
        { user: { ...user, emailVerified: true, accessToken } },
        'Login successful'
      )
    );
    return;
  }
);
