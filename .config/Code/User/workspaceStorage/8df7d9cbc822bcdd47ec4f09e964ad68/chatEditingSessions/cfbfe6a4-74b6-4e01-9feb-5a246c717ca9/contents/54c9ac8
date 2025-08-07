import { Router } from 'express';
import { authMiddleware } from '../middleware/auth';
import { validate } from '../middleware/validation';
import DiscussionController from '../controllers/discussion.controller';
import {
  createDiscussionSchema,
  updateDiscussionSchema,
  createCommentSchema,
  updateCommentSchema,
  replyToDiscussionSchema,
} from '../validations/discussion.validation';

const router = Router();

// Apply authentication middleware to all routes
router.use(authMiddleware);

// Discussion routes
router.post(
  '/',
  validate(createDiscussionSchema),
  DiscussionController.createDiscussion
);

// Get discussions for a project
router.get('/project/:projectId', DiscussionController.getProjectDiscussions);

// Get discussions for a task
router.get('/task/:taskId', DiscussionController.getTaskDiscussions);

// Get a specific discussion with replies and comments
router.get('/:discussionId', DiscussionController.getDiscussion);

// Update a discussion
router.put(
  '/:discussionId',
  validate(updateDiscussionSchema),
  DiscussionController.updateDiscussion
);

// Delete a discussion
router.delete('/:discussionId', DiscussionController.deleteDiscussion);

// Reply to a discussion
router.post(
  '/:discussionId/reply',
  validate(replyToDiscussionSchema),
  DiscussionController.replyToDiscussion
);

// Comment routes
// Get comments for a discussion
router.get(
  '/:discussionId/comments',
  DiscussionController.getDiscussionComments
);

// Add a comment to a discussion
router.post(
  '/comments',
  validate(createCommentSchema),
  DiscussionController.addComment
);

// Update a comment
router.put(
  '/comments/:commentId',
  validate(updateCommentSchema),
  DiscussionController.updateComment
);

// Delete a comment
router.delete('/comments/:commentId', DiscussionController.deleteComment);

// Reply to a comment
router.post(
  '/comments/:commentId/reply',
  validate(createCommentSchema),
  DiscussionController.replyToComment
);

export default router;
