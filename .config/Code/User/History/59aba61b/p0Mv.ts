import { Request, Response } from 'express';
import { asyncHandler } from '../middleware/asyncHandler';
import { DiscussionService } from '../services/discussion.service';
import {
  createDiscussionSchema,
  updateDiscussionSchema,
  getDiscussionsQuerySchema,
  createCommentSchema,
  updateCommentSchema,
  getCommentsQuerySchema,
  replyToDiscussionSchema,
} from '../validations/discussion.validation';
import { AppError } from '../utils/errors';

export class DiscussionController {
  // Create a new discussion
  static createDiscussion = asyncHandler(async (req: Request, res: Response) => {
    const validatedData = createDiscussionSchema.parse(req.body);
    const authorId = req.user!.id;

    const discussion = await DiscussionService.createDiscussion({
      ...validatedData,
      authorId,
    });

    res.status(201).json({
      success: true,
      message: 'Discussion created successfully',
      data: discussion,
    });
  });

  // Get discussions for a project
  static getProjectDiscussions = asyncHandler(async (req: Request, res: Response) => {
    const { projectId } = req.params;
    const query = getDiscussionsQuerySchema.parse({
      ...req.query,
      projectId,
    });

    const result = await DiscussionService.getProjectDiscussions({
      projectId,
      page: query.page,
      limit: query.limit,
    });

    res.json({
      success: true,
      message: 'Discussions retrieved successfully',
      data: result,
    });
  });

  // Get discussions for a task
  static getTaskDiscussions = asyncHandler(async (req: Request, res: Response) => {
    const { taskId } = req.params;
    const query = getDiscussionsQuerySchema.parse({
      ...req.query,
      taskId,
    });

    const result = await DiscussionService.getTaskDiscussions({
      taskId,
      page: query.page,
      limit: query.limit,
    });

    res.json({
      success: true,
      message: 'Task discussions retrieved successfully',
      data: result,
    });
  });

  // Get a single discussion with replies and comments
  static getDiscussion = asyncHandler(async (req: Request, res: Response) => {
    const { discussionId } = req.params;

    if (!discussionId) {
      throw new AppError('Discussion ID is required', 400);
    }

    const discussion = await DiscussionService.getDiscussionById(discussionId);

    res.json({
      success: true,
      message: 'Discussion retrieved successfully',
      data: discussion,
    });
  });

  // Update a discussion
  static updateDiscussion = asyncHandler(async (req: Request, res: Response) => {
    const { discussionId } = req.params;
    const validatedData = updateDiscussionSchema.parse(req.body);
    const authorId = req.user!.id;

    if (!discussionId) {
      throw new AppError('Discussion ID is required', 400);
    }

    const discussion = await DiscussionService.updateDiscussion(
      discussionId,
      authorId,
      validatedData
    );

    res.json({
      success: true,
      message: 'Discussion updated successfully',
      data: discussion,
    });
  });

  // Delete a discussion
  static deleteDiscussion = asyncHandler(async (req: Request, res: Response) => {
    const { discussionId } = req.params;
    const authorId = req.user!.id;

    if (!discussionId) {
      throw new AppError('Discussion ID is required', 400);
    }

    const result = await DiscussionService.deleteDiscussion(discussionId, authorId);

    res.json({
      success: true,
      message: result.message,
    });
  });

  // Reply to a discussion (create nested discussion)
  static replyToDiscussion = asyncHandler(async (req: Request, res: Response) => {
    const { discussionId } = req.params;
    const validatedData = replyToDiscussionSchema.parse({
      ...req.body,
      parentDiscussionId: discussionId,
    });
    const authorId = req.user!.id;

    // Get parent discussion to inherit project/task context
    const parentDiscussion = await DiscussionService.getDiscussionById(discussionId);

    const reply = await DiscussionService.createDiscussion({
      title: validatedData.title,
      content: validatedData.content,
      authorId,
      projectId: parentDiscussion.projectId || undefined,
      taskId: parentDiscussion.taskId || undefined,
      parentDiscussionId: discussionId,
    });

    res.status(201).json({
      success: true,
      message: 'Reply created successfully',
      data: reply,
    });
  });

  // Get comments for a discussion
  static getDiscussionComments = asyncHandler(async (req: Request, res: Response) => {
    const { discussionId } = req.params;
    const query = getCommentsQuerySchema.parse({
      ...req.query,
      discussionId,
    });

    const result = await DiscussionService.getDiscussionComments(
      discussionId,
      query.page,
      query.limit
    );

    res.json({
      success: true,
      message: 'Comments retrieved successfully',
      data: result,
    });
  });

  // Add a comment to a discussion
  static addComment = asyncHandler(async (req: Request, res: Response) => {
    const validatedData = createCommentSchema.parse(req.body);
    const authorId = req.user!.id;

    const comment = await DiscussionService.addComment({
      ...validatedData,
      authorId,
    });

    res.status(201).json({
      success: true,
      message: 'Comment added successfully',
      data: comment,
    });
  });

  // Update a comment
  static updateComment = asyncHandler(async (req: Request, res: Response) => {
    const { commentId } = req.params;
    const validatedData = updateCommentSchema.parse(req.body);
    const authorId = req.user!.id;

    if (!commentId) {
      throw new AppError('Comment ID is required', 400);
    }

    const comment = await DiscussionService.updateComment(
      commentId,
      authorId,
      validatedData.content
    );

    res.json({
      success: true,
      message: 'Comment updated successfully',
      data: comment,
    });
  });

  // Delete a comment
  static deleteComment = asyncHandler(async (req: Request, res: Response) => {
    const { commentId } = req.params;
    const authorId = req.user!.id;

    if (!commentId) {
      throw new AppError('Comment ID is required', 400);
    }

    const result = await DiscussionService.deleteComment(commentId, authorId);

    res.json({
      success: true,
      message: result.message,
    });
  });

  // Reply to a comment (create nested comment)
  static replyToComment = asyncHandler(async (req: Request, res: Response) => {
    const { commentId } = req.params;
    const validatedData = createCommentSchema.parse({
      ...req.body,
      parentCommentId: commentId,
    });
    const authorId = req.user!.id;

    const reply = await DiscussionService.addComment({
      content: validatedData.content,
      discussionId: validatedData.discussionId,
      authorId,
      parentCommentId: commentId,
    });

    res.status(201).json({
      success: true,
      message: 'Comment reply created successfully',
      data: reply,
    });
  });
}

export default DiscussionController;
