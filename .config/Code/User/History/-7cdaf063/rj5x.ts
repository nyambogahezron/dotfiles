import { Router } from 'express';
import { EmailService } from '../services/email.service';
import AsyncHandler from '../middleware/asyncHandler';
import { Request, Response } from 'express';
import { formatResponse } from '../utils/helpers';

const router = Router();

// Test endpoint to see email logging in development
router.post('/test-email', AsyncHandler(async (req: Request, res: Response) => {
  const { email, type } = req.body;
  
  if (!email) {
    return res.status(400).json({ 
      error: 'Email address is required' 
    });
  }

  switch (type) {
    case 'otp':
      await EmailService.sendTestOTPEmail(email);
      break;
    case 'basic':
    default:
      await EmailService.sendTestEmail(email);
      break;
  }

  res.json(formatResponse(
    null, 
    `Test email sent to ${email}. Check console logs for email content in development mode.`
  ));
}));

// Test endpoint to send verification OTP
router.post('/test-verification-otp', AsyncHandler(async (req: Request, res: Response) => {
  const { email, name } = req.body;
  
  if (!email || !name) {
    return res.status(400).json({ 
      error: 'Email and name are required' 
    });
  }

  const testOTP = '654321';
  
  await EmailService.sendVerificationOTPEmail({
    email,
    name,
    otp: testOTP
  });

  res.json(formatResponse(
    { testOTP }, 
    `Verification OTP sent to ${email}. Check console logs for email content in development mode.`
  ));
}));

// Test endpoint to send login OTP
router.post('/test-login-otp', AsyncHandler(async (req: Request, res: Response) => {
  const { email, name } = req.body;
  
  if (!email || !name) {
    return res.status(400).json({ 
      error: 'Email and name are required' 
    });
  }

  const testOTP = '789012';
  
  await EmailService.sendLoginOTPEmail({
    email,
    name,
    otp: testOTP
  });

  res.json(formatResponse(
    { testOTP }, 
    `Login OTP sent to ${email}. Check console logs for email content in development mode.`
  ));
}));

export default router;
