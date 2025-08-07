import { db } from '../database/connection';
import { messages, users, projectMembers } from '../database/schema';
import { eq, and, desc, lt, gt } from 'drizzle-orm';
import { logger } from '../utils/logger';
import CustomError, {
  ForbiddenError,
  NotFoundError,
  InternalServerError,
} from '../utils/errors';

export class ChatService {
  // Send a message
  static async sendMessage(data: {
    content: string;
    senderId: string;
    projectId: string;
    messageType?: 'text' | 'file' | 'image';
    metadata?: string;
  }) {
    try {
      // Verify user is a member of the project
      const [membership] = await db
        .select()
        .from(projectMembers)
        .where(
          and(
            eq(projectMembers.projectId, data.projectId),
            eq(projectMembers.userId, data.senderId)
          )
        )
        .limit(1);

      if (!membership) {
        throw new ForbiddenError('Not authorized to send messages to this project');
      }

      // Insert message
      const [message] = await db
        .insert(messages)
        .values({
          content: data.content,
          senderId: data.senderId,
          projectId: data.projectId,
          messageType: data.messageType || 'text',
          metadata: data.metadata || null,
        })
        .returning();

      // Fetch message with sender details
      const [fullMessage] = await db
        .select({
          id: messages.id,
          content: messages.content,
          messageType: messages.messageType,
          metadata: messages.metadata,
          createdAt: messages.createdAt,
          updatedAt: messages.updatedAt,
          sender: {
            id: users.id,
            firstName: users.firstName,
            lastName: users.lastName,
            email: users.email,
          },
          projectId: messages.projectId,
        })
        .from(messages)
        .innerJoin(users, eq(messages.senderId, users.id))
        .where(eq(messages.id, message.id))
        .limit(1);

      return fullMessage;
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error sending message:', error);
      throw new InternalServerError('Failed to send message');
    }
  }

  // Get messages for a project
  static async getProjectMessages({
    projectId,
    userId,
    page = 1,
    limit = 50,
    before,
    after,
  }: {
    projectId: string;
    userId: string;
    page?: number;
    limit?: number;
    before?: Date;
    after?: Date;
  }) {
    try {
      // Verify user is a member of the project
      const [membership] = await db
        .select()
        .from(projectMembers)
        .where(
          and(
            eq(projectMembers.projectId, projectId),
            eq(projectMembers.userId, userId)
          )
        )
        .limit(1);

      if (!membership) {
        throw new ForbiddenError('Not authorized to view messages in this project');
      }

      const offset = (page - 1) * limit;

      // Build where conditions
      const whereConditions = [eq(messages.projectId, projectId)];

      if (before) {
        whereConditions.push(lt(messages.createdAt, before));
      }

      if (after) {
        whereConditions.push(gt(messages.createdAt, after));
      }

      // Fetch messages
      const messagesList = await db
        .select({
          id: messages.id,
          content: messages.content,
          messageType: messages.messageType,
          metadata: messages.metadata,
          createdAt: messages.createdAt,
          updatedAt: messages.updatedAt,
          sender: {
            id: users.id,
            firstName: users.firstName,
            lastName: users.lastName,
            email: users.email,
          },
        })
        .from(messages)
        .innerJoin(users, eq(messages.senderId, users.id))
        .where(and(...whereConditions))
        .orderBy(desc(messages.createdAt))
        .limit(limit)
        .offset(offset);

      return {
        messages: messagesList,
        page,
        limit,
        hasMore: messagesList.length === limit,
      };
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error fetching project messages:', error);
      throw new InternalServerError('Failed to fetch messages');
    }
  }

  // Get recent messages for a project (used for initial load)
  static async getRecentMessages(
    projectId: string,
    userId: string,
    limit = 50
  ) {
    try {
      // Verify user is a member of the project
      const [membership] = await db
        .select()
        .from(projectMembers)
        .where(
          and(
            eq(projectMembers.projectId, projectId),
            eq(projectMembers.userId, userId)
          )
        )
        .limit(1);

      if (!membership) {
        throw new AppError(
          'Not authorized to view messages in this project',
          403
        );
      }

      // Fetch recent messages
      const messagesList = await db
        .select({
          id: messages.id,
          content: messages.content,
          messageType: messages.messageType,
          metadata: messages.metadata,
          createdAt: messages.createdAt,
          updatedAt: messages.updatedAt,
          sender: {
            id: users.id,
            firstName: users.firstName,
            lastName: users.lastName,
            email: users.email,
          },
        })
        .from(messages)
        .innerJoin(users, eq(messages.senderId, users.id))
        .where(eq(messages.projectId, projectId))
        .orderBy(desc(messages.createdAt))
        .limit(limit);

      // Return in chronological order (oldest first)
      return messagesList.reverse();
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error fetching recent messages:', error);
      throw new InternalServerError('Failed to fetch recent messages');
    }
  }

  // Update a message (only by sender)
  static async updateMessage(
    messageId: string,
    senderId: string,
    content: string
  ) {
    try {
      // Check if user is the sender
      const [existingMessage] = await db
        .select()
        .from(messages)
        .where(eq(messages.id, messageId))
        .limit(1);

      if (!existingMessage) {
        throw new NotFoundError('Message not found');
      }

      if (existingMessage.senderId !== senderId) {
        throw new ForbiddenError('Not authorized to update this message');
      }

      await db
        .update(messages)
        .set({
          content,
          updatedAt: new Date(),
        })
        .where(eq(messages.id, messageId));

      // Fetch updated message with sender details
      const [fullMessage] = await db
        .select({
          id: messages.id,
          content: messages.content,
          messageType: messages.messageType,
          metadata: messages.metadata,
          createdAt: messages.createdAt,
          updatedAt: messages.updatedAt,
          sender: {
            id: users.id,
            firstName: users.firstName,
            lastName: users.lastName,
            email: users.email,
          },
          projectId: messages.projectId,
        })
        .from(messages)
        .innerJoin(users, eq(messages.senderId, users.id))
        .where(eq(messages.id, messageId))
        .limit(1);

      return fullMessage;
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error updating message:', error);
      throw new InternalServerError('Failed to update message');
    }
  }

  // Delete a message (only by sender)
  static async deleteMessage(messageId: string, senderId: string) {
    try {
      // Check if user is the sender
      const [existingMessage] = await db
        .select()
        .from(messages)
        .where(eq(messages.id, messageId))
        .limit(1);

      if (!existingMessage) {
        throw new NotFoundError('Message not found');
      }

      if (existingMessage.senderId !== senderId) {
        throw new ForbiddenError('Not authorized to delete this message');
      }

      await db.delete(messages).where(eq(messages.id, messageId));

      return {
        message: 'Message deleted successfully',
        messageId,
        projectId: existingMessage.projectId,
      };
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error deleting message:', error);
      throw new InternalServerError('Failed to delete message');
    }
  }

  // Get message by ID (with authorization check)
  static async getMessageById(messageId: string, userId: string) {
    try {
      const [message] = await db
        .select({
          id: messages.id,
          content: messages.content,
          messageType: messages.messageType,
          metadata: messages.metadata,
          createdAt: messages.createdAt,
          updatedAt: messages.updatedAt,
          projectId: messages.projectId,
          sender: {
            id: users.id,
            firstName: users.firstName,
            lastName: users.lastName,
            email: users.email,
          },
        })
        .from(messages)
        .innerJoin(users, eq(messages.senderId, users.id))
        .where(eq(messages.id, messageId))
        .limit(1);

      if (!message) {
        throw new NotFoundError('Message not found');
      }

      // Verify user is a member of the project
      const [membership] = await db
        .select()
        .from(projectMembers)
        .where(
          and(
            eq(projectMembers.projectId, message.projectId),
            eq(projectMembers.userId, userId)
          )
        )
        .limit(1);

      if (!membership) {
        throw new ForbiddenError('Not authorized to view this message');
      }

      return message;
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error fetching message:', error);
      throw new InternalServerError('Failed to fetch message');
    }
  }

  // Get project chat participants
  static async getChatParticipants(projectId: string, userId: string) {
    try {
      // Verify user is a member of the project
      const [membership] = await db
        .select()
        .from(projectMembers)
        .where(
          and(
            eq(projectMembers.projectId, projectId),
            eq(projectMembers.userId, userId)
          )
        )
        .limit(1);

      if (!membership) {
        throw new AppError(
          'Not authorized to view participants in this project',
          403
        );
      }

      // Get all project members
      const participants = await db
        .select({
          id: users.id,
          firstName: users.firstName,
          lastName: users.lastName,
          email: users.email,
          role: projectMembers.role,
          joinedAt: projectMembers.joinedAt,
        })
        .from(projectMembers)
        .innerJoin(users, eq(projectMembers.userId, users.id))
        .where(eq(projectMembers.projectId, projectId))
        .orderBy(users.firstName, users.lastName);

      return participants;
    } catch (error) {
      if (error instanceof CustomError) throw error;
      logger.error('Error fetching chat participants:', error);
      throw new InternalServerError('Failed to fetch participants');
    }
  }
}

export default ChatService;
