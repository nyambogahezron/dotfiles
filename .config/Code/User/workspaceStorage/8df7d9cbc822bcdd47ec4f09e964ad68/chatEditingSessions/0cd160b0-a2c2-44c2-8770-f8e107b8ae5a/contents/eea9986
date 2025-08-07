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

const router = Router();

router.post('/register', register);
router.post('/login', login);
router.get('/verify-email', verifyEmail);
router.post('/resend-verification', resendVerificationEmail);
router.post('/verify-link', requestVerifyLink);
router.post('/verify', verifyMagicLink);

router.use(authMiddleware);
router.post('/logout', logout);
router.get('/me', me);

export default router;
