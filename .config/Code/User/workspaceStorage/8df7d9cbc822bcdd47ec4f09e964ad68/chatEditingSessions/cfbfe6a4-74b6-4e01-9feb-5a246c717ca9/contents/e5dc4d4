import { Router } from 'express';
import { authMiddleware } from '../middleware/auth';
import { validate } from '../middleware/validation';
import ChatController from '../controllers/chat.controller';
import { sendMessageSchema } from '../validations/chat.validation';

const router = Router();

// Apply authentication middleware to all routes
router.use(authMiddleware);

// Send a message
router.post(
  '/messages',
  validate(sendMessageSchema),
  ChatController.sendMessage
);

// Get messages for a project
router.get('/projects/:projectId/messages', ChatController.getProjectMessages);

// Get recent messages for a project (initial load)
router.get(
  '/projects/:projectId/messages/recent',
  ChatController.getRecentMessages
);

// Get, update, delete specific message
router.get('/messages/:messageId', ChatController.getMessage);
router.put('/messages/:messageId', ChatController.updateMessage);
router.delete('/messages/:messageId', ChatController.deleteMessage);

// Get chat participants for a project
router.get(
  '/projects/:projectId/participants',
  ChatController.getChatParticipants
);

export default router;
