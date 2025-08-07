import { z } from 'zod';

// Discussion validation schemas
export const createDiscussionSchema = z.object({
  title: z.string().min(1, 'Title is required').max(255, 'Title too long'),
  content: z.string().min(1, 'Content is required').max(10000, 'Content too long'),
  projectId: z.uuid('Invalid project ID').optional(),
  taskId: z.uuid('Invalid task ID').optional(),
  parentDiscussionId: z.uuid('Invalid parent discussion ID').optional(),
}).refine((data) => data.projectId || data.taskId, {
  message: 'Either projectId or taskId must be provided',
  path: ['projectId'],
});

export const updateDiscussionSchema = z.object({
  title: z.string().min(1, 'Title is required').max(255, 'Title too long').optional(),
  content: z.string().min(1, 'Content is required').max(10000, 'Content too long').optional(),
}).refine((data) => data.title || data.content, {
  message: 'At least one field (title or content) must be provided',
});

export const getDiscussionsQuerySchema = z.object({
  page: z.string().transform(Number).optional().default(1),
  limit: z.string().transform(Number).optional().default(20),
  projectId: z.uuid('Invalid project ID').optional(),
  taskId: z.uuid('Invalid task ID').optional(),
}).refine((data) => data.projectId || data.taskId, {
  message: 'Either projectId or taskId must be provided',
  path: ['projectId'],
});

// Comment validation schemas
export const createCommentSchema = z.object({
  content: z.string().min(1, 'Content is required').max(5000, 'Content too long'),
  discussionId: z.uuid('Invalid discussion ID'),
  parentCommentId: z.uuid('Invalid parent comment ID').optional(),
});

export const updateCommentSchema = z.object({
  content: z.string().min(1, 'Content is required').max(5000, 'Content too long'),
});

export const getCommentsQuerySchema = z.object({
  page: z.string().transform(Number).optional().default(1),
  limit: z.string().transform(Number).optional().default(50),
  discussionId: z.uuid('Invalid discussion ID'),
});

// Reply to discussion schema (creating a nested discussion)
export const replyToDiscussionSchema = z.object({
  title: z.string().min(1, 'Title is required').max(255, 'Title too long'),
  content: z.string().min(1, 'Content is required').max(10000, 'Content too long'),
  parentDiscussionId: z.uuid('Invalid parent discussion ID'),
});

// Type exports
export type CreateDiscussionInput = z.infer<typeof createDiscussionSchema>;
export type UpdateDiscussionInput = z.infer<typeof updateDiscussionSchema>;
export type GetDiscussionsQuery = z.infer<typeof getDiscussionsQuerySchema>;
export type CreateCommentInput = z.infer<typeof createCommentSchema>;
export type UpdateCommentInput = z.infer<typeof updateCommentSchema>;
export type GetCommentsQuery = z.infer<typeof getCommentsQuerySchema>;
export type ReplyToDiscussionInput = z.infer<typeof replyToDiscussionSchema>;
