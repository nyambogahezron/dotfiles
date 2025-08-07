import { Router } from 'express';
import {
  register,
  login,
  logout,
  me,
  requestVerifyLink,
  verifyMagicLink,
  verifyEmail,
  resendVerificationEmail,
} from '../controllers/auth.controller';

import { authMiddleware } from '../middleware/auth';
import { validateSchema } from '../middleware/validation';
import {
  registerSchema,
  loginSchema,
  resendVerificationSchema,
} from '../validations/auth.validation';

const router = Router();

router.post('/register', validateSchema(registerSchema), register);
router.post('/login', validateSchema(loginSchema), login);
router.get('/verify-email', verifyEmail);
router.post('/resend-verification', validateSchema(resendVerificationSchema), resendVerificationEmail);
router.post('/verify-link', requestVerifyLink);
router.post('/verify', verifyMagicLink);

router.use(authMiddleware);
router.post('/logout', logout);
router.get('/me', me);

export default router;
