import { Router } from 'express';
import {
  register,
  login,
  logout,
  me,
  requestLoginOTP,
  verifyOTP,
  resendVerificationEmail,
} from '../controllers/auth.controller';

import { authMiddleware } from '../middleware/auth';
import { validateSchema } from '../middleware/validation';
import {
  registerSchema,
  loginSchema,
  resendVerificationSchema,
  verifyOTPSchema,
  requestLoginOTPSchema,
} from '../validations/auth.validation';

const router = Router();

router.post('/register', validateSchema(registerSchema), register);
router.post('/login', validateSchema(loginSchema), login);
router.post('/verify-otp', validateSchema(verifyOTPSchema), verifyOTP);
router.post(
  '/resend-verification',
  validateSchema(resendVerificationSchema),
  resendVerificationEmail
);
router.post(
  '/request-login-otp',
  validateSchema(requestLoginOTPSchema),
  requestLoginOTP
);

router.use(authMiddleware);
router.post('/logout', logout);
router.get('/me', me);

export default router;
