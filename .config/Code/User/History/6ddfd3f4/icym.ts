import { OTPService } from '../otp';

describe('OTPService', () => {
  const userId = 'test-user-123';
  const type = 'email_verification';

  test('should generate a 6-digit OTP', () => {
    const { otp, signedToken } = OTPService.generateOTP(userId, type);
    
    expect(otp).toMatch(/^\d{6}$/);
    expect(signedToken).toBeDefined();
    expect(typeof signedToken).toBe('string');
  });

  test('should verify valid OTP successfully', () => {
    const { otp, signedToken } = OTPService.generateOTP(userId, type);
    
    const verification = OTPService.verifyOTP(otp, signedToken, type);
    
    expect(verification.isValid).toBe(true);
    expect(verification.userId).toBe(userId);
    expect(verification.error).toBeUndefined();
  });

  test('should reject invalid OTP', () => {
    const { signedToken } = OTPService.generateOTP(userId, type);
    const invalidOTP = '999999';
    
    const verification = OTPService.verifyOTP(invalidOTP, signedToken, type);
    
    expect(verification.isValid).toBe(false);
    expect(verification.error).toBe('Invalid OTP');
  });

  test('should reject wrong token type', () => {
    const { otp, signedToken } = OTPService.generateOTP(userId, 'email_verification');
    
    const verification = OTPService.verifyOTP(otp, signedToken, 'login');
    
    expect(verification.isValid).toBe(false);
    expect(verification.error).toBe('Invalid token type');
  });

  test('should hash and verify OTP correctly', () => {
    const otp = '123456';
    const hash = OTPService.hashOTP(otp);
    
    expect(hash).toBeDefined();
    expect(hash).not.toBe(otp);
    expect(OTPService.verifyHashedOTP(otp, hash)).toBe(true);
    expect(OTPService.verifyHashedOTP('654321', hash)).toBe(false);
  });
});
