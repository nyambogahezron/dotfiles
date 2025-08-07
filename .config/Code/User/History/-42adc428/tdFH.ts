import crypto from 'crypto';
import jwt from 'jsonwebtoken';

const OTP_SECRET = process.env.OTP_SECRET || 'default-otp-secret-key';
const OTP_EXPIRY = 15 * 60 * 1000; // 15 minutes

export interface OTPPayload {
  otp: string;
  userId: string;
  type: 'login' | 'email_verification' | 'password_reset';
  expiresAt: number;
}

export class OTPService {
  /**
   * Generate a 6-digit OTP and create a signed token
   */
  static generateOTP(userId: string, type: OTPPayload['type']): { otp: string; signedToken: string } {
    // Generate random 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    
    const payload: OTPPayload = {
      otp,
      userId,
      type,
      expiresAt: Date.now() + OTP_EXPIRY
    };

    // Create signed token containing the OTP and metadata
    const signedToken = jwt.sign(payload, OTP_SECRET, { expiresIn: '15m' });

    return { otp, signedToken };
  }

  /**
   * Verify OTP against signed token
   */
  static verifyOTP(otp: string, signedToken: string, expectedType: OTPPayload['type']): {
    isValid: boolean;
    userId?: string;
    error?: string;
  } {
    try {
      // Verify and decode the signed token
      const payload = jwt.verify(signedToken, OTP_SECRET) as OTPPayload;

      // Check if token type matches expected type
      if (payload.type !== expectedType) {
        return { isValid: false, error: 'Invalid token type' };
      }

      // Check if OTP matches
      if (payload.otp !== otp) {
        return { isValid: false, error: 'Invalid OTP' };
      }

      // Check if token has expired (double check with JWT expiry)
      if (payload.expiresAt < Date.now()) {
        return { isValid: false, error: 'OTP has expired' };
      }

      return { isValid: true, userId: payload.userId };
    } catch (error) {
      if (error instanceof jwt.TokenExpiredError) {
        return { isValid: false, error: 'OTP has expired' };
      }
      if (error instanceof jwt.JsonWebTokenError) {
        return { isValid: false, error: 'Invalid token' };
      }
      return { isValid: false, error: 'Token verification failed' };
    }
  }

  /**
   * Generate a hash for storing OTP in database (for additional security)
   */
  static hashOTP(otp: string): string {
    return crypto.createHash('sha256').update(otp).digest('hex');
  }

  /**
   * Verify hashed OTP
   */
  static verifyHashedOTP(otp: string, hash: string): boolean {
    const otpHash = this.hashOTP(otp);
    return crypto.timingSafeEqual(Buffer.from(otpHash), Buffer.from(hash));
  }
}
