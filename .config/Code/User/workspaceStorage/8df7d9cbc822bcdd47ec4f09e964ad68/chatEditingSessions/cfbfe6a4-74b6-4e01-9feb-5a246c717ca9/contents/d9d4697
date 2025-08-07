import { Request, Response } from 'express';
import AsyncHandler from '../middleware/asyncHandler';
import { ChatService } from '../services/chat.service';
import {
  sendMessageSchema,
  getMessagesQuerySchema,
} from '../validations/chat.validation';
import { BadRequestError } from '../utils/errors';

export class ChatController {
  // Send a message
  static sendMessage = AsyncHandler(async (req: Request, res: Response) => {
    const validatedData = sendMessageSchema.parse(req.body);
    const senderId = req.user?.id;

    if (!senderId) {
      throw new BadRequestError('User authentication required');
    }

    const message = await ChatService.sendMessage({
      ...validatedData,
      senderId,
    });

    res.status(201).json({
      success: true,
      message: 'Message sent successfully',
      data: message,
    });
  });

  // Get messages for a project
  static getProjectMessages = AsyncHandler(
    async (req: Request, res: Response) => {
      const { projectId } = req.params;
      const query = getMessagesQuerySchema.parse({
        ...req.query,
        projectId,
      });
      const userId = req.user?.id;

      if (!userId) {
        throw new BadRequestError('User authentication required');
      }

      const result = await ChatService.getProjectMessages({
        projectId,
        userId,
        page: query.page,
        limit: query.limit,
        before: query.before,
        after: query.after,
      });

      res.json({
        success: true,
        message: 'Messages retrieved successfully',
        data: result,
      });
    }
  );

  // Get recent messages for a project (initial load)
  static getRecentMessages = AsyncHandler(
    async (req: Request, res: Response) => {
      const { projectId } = req.params;
      const { limit = 50 } = req.query;
      const userId = req.user?.id;

      if (!userId) {
        throw new BadRequestError('User authentication required');
      }

      const messages = await ChatService.getRecentMessages(
        projectId,
        userId,
        Number(limit)
      );

      res.json({
        success: true,
        message: 'Recent messages retrieved successfully',
        data: messages,
      });
    }
  );

  // Update a message
  static updateMessage = AsyncHandler(async (req: Request, res: Response) => {
    const { messageId } = req.params;
    const { content } = req.body;
    const senderId = req.user?.id;

    if (!messageId) {
      throw new BadRequestError('Message ID is required');
    }

    if (!senderId) {
      throw new BadRequestError('User authentication required');
    }

    if (
      !content ||
      typeof content !== 'string' ||
      content.trim().length === 0
    ) {
      throw new BadRequestError('Message content is required');
    }

    const message = await ChatService.updateMessage(
      messageId,
      senderId,
      content
    );

    res.json({
      success: true,
      message: 'Message updated successfully',
      data: message,
    });
  });

  // Delete a message
  static deleteMessage = AsyncHandler(async (req: Request, res: Response) => {
    const { messageId } = req.params;
    const senderId = req.user?.id;

    if (!messageId) {
      throw new BadRequestError('Message ID is required');
    }

    if (!senderId) {
      throw new BadRequestError('User authentication required');
    }

    const result = await ChatService.deleteMessage(messageId, senderId);

    res.json({
      success: true,
      message: result.message,
      data: {
        messageId: result.messageId,
        projectId: result.projectId,
      },
    });
  });

  // Get a specific message
  static getMessage = AsyncHandler(async (req: Request, res: Response) => {
    const { messageId } = req.params;
    const userId = req.user?.id;

    if (!messageId) {
      throw new BadRequestError('Message ID is required');
    }

    if (!userId) {
      throw new BadRequestError('User authentication required');
    }

    const message = await ChatService.getMessageById(messageId, userId);

    res.json({
      success: true,
      message: 'Message retrieved successfully',
      data: message,
    });
  });

  // Get chat participants for a project
  static getChatParticipants = AsyncHandler(
    async (req: Request, res: Response) => {
      const { projectId } = req.params;
      const userId = req.user?.id;

      if (!projectId) {
        throw new BadRequestError('Project ID is required');
      }

      if (!userId) {
        throw new BadRequestError('User authentication required');
      }

      const participants = await ChatService.getChatParticipants(
        projectId,
        userId
      );

      res.json({
        success: true,
        message: 'Chat participants retrieved successfully',
        data: participants,
      });
    }
  );
}

export default ChatController;
