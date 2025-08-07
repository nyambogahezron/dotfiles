import { z } from 'zod';
import { TaskStatus, TaskPriority } from '@taskflow/shared-types';

// User validation schemas
export const loginSchema = z.object({
  email: z.string().email('Please enter a valid email address'),
  password: z.string().min(1, 'Password is required'),
});

export const registerSchema = z
  .object({
    email: z.string().email('Please enter a valid email address'),
    username: z
      .string()
      .min(3, 'Username must be at least 3 characters')
      .max(30, 'Username must be less than 30 characters')
      .regex(
        /^[a-zA-Z0-9_]+$/,
        'Username can only contain letters, numbers, and underscores'
      ),
    password: z
      .string()
      .min(8, 'Password must be at least 8 characters')
      .regex(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
        'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character'
      ),
    confirmPassword: z.string(),
    firstName: z.string().optional(),
    lastName: z.string().optional(),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ['confirmPassword'],
  });

export const updateProfileSchema = z.object({
  username: z
    .string()
    .min(3, 'Username must be at least 3 characters')
    .max(30, 'Username must be less than 30 characters')
    .regex(
      /^[a-zA-Z0-9_]+$/,
      'Username can only contain letters, numbers, and underscores'
    )
    .optional(),
  firstName: z
    .string()
    .max(50, 'First name must be less than 50 characters')
    .optional(),
  lastName: z
    .string()
    .max(50, 'Last name must be less than 50 characters')
    .optional(),
  email: z.string().email('Please enter a valid email address').optional(),
});

// Task validation schemas
export const createTaskSchema = z.object({
  title: z
    .string()
    .min(1, 'Task title is required')
    .max(200, 'Task title must be less than 200 characters'),
  description: z
    .string()
    .max(1000, 'Task description must be less than 1000 characters')
    .optional(),
  status: z.nativeEnum(TaskStatus).default(TaskStatus.TODO),
  priority: z.nativeEnum(TaskPriority).default(TaskPriority.MEDIUM),
  assigneeId: z.string().uuid('Invalid assignee ID').optional(),
  projectId: z.string().uuid('Invalid project ID').optional(),
  dueDate: z.string().datetime('Invalid due date').optional(),
});

export const updateTaskSchema = z.object({
  title: z
    .string()
    .min(1, 'Task title is required')
    .max(200, 'Task title must be less than 200 characters')
    .optional(),
  description: z
    .string()
    .max(1000, 'Task description must be less than 1000 characters')
    .optional(),
  status: z.nativeEnum(TaskStatus).optional(),
  priority: z.nativeEnum(TaskPriority).optional(),
  assigneeId: z.string().uuid('Invalid assignee ID').nullable().optional(),
  projectId: z.string().uuid('Invalid project ID').nullable().optional(),
  dueDate: z.string().datetime('Invalid due date').nullable().optional(),
});

// Project validation schemas
export const createProjectSchema = z.object({
  name: z
    .string()
    .min(1, 'Project name is required')
    .max(100, 'Project name must be less than 100 characters'),
  description: z
    .string()
    .max(500, 'Project description must be less than 500 characters')
    .optional(),
  members: z.array(z.string().uuid('Invalid member ID')).default([]),
});

export const updateProjectSchema = z.object({
  name: z
    .string()
    .min(1, 'Project name is required')
    .max(100, 'Project name must be less than 100 characters')
    .optional(),
  description: z
    .string()
    .max(500, 'Project description must be less than 500 characters')
    .optional(),
  members: z.array(z.string().uuid('Invalid member ID')).optional(),
});

// Search and filter schemas
export const searchSchema = z.object({
  query: z
    .string()
    .max(100, 'Search query must be less than 100 characters')
    .optional(),
  page: z.number().int().min(1).default(1),
  limit: z.number().int().min(1).max(100).default(20),
  sortBy: z.string().optional(),
  sortOrder: z.enum(['asc', 'desc']).default('desc'),
});

export const taskFilterSchema = searchSchema.extend({
  status: z.nativeEnum(TaskStatus).optional(),
  priority: z.nativeEnum(TaskPriority).optional(),
  assigneeId: z.string().uuid('Invalid assignee ID').optional(),
  projectId: z.string().uuid('Invalid project ID').optional(),
  dueDateFrom: z.string().datetime('Invalid date').optional(),
  dueDateTo: z.string().datetime('Invalid date').optional(),
});

// Common validation schemas
export const idSchema = z.object({
  id: z.string().uuid('Invalid ID format'),
});

export const emailSchema = z.object({
  email: z.string().email('Please enter a valid email address'),
});

export const passwordResetSchema = z.object({
  email: z.string().email('Please enter a valid email address'),
});

export const newPasswordSchema = z
  .object({
    token: z.string().min(1, 'Reset token is required'),
    password: z
      .string()
      .min(8, 'Password must be at least 8 characters')
      .regex(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
        'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character'
      ),
    confirmPassword: z.string(),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ['confirmPassword'],
  });

// Type exports for use in components
export type LoginFormData = z.infer<typeof loginSchema>;
export type RegisterFormData = z.infer<typeof registerSchema>;
export type UpdateProfileFormData = z.infer<typeof updateProfileSchema>;
export type CreateTaskFormData = z.infer<typeof createTaskSchema>;
export type UpdateTaskFormData = z.infer<typeof updateTaskSchema>;
export type CreateProjectFormData = z.infer<typeof createProjectSchema>;
export type UpdateProjectFormData = z.infer<typeof updateProjectSchema>;
export type SearchFormData = z.infer<typeof searchSchema>;
export type TaskFilterFormData = z.infer<typeof taskFilterSchema>;
export type PasswordResetFormData = z.infer<typeof passwordResetSchema>;
export type NewPasswordFormData = z.infer<typeof newPasswordSchema>;

// Validation helper functions
export const validateEmail = (email: string): boolean => {
  return emailSchema.shape.email.safeParse(email).success;
};

export const validatePassword = (password: string): boolean => {
  return registerSchema.shape.password.safeParse(password).success;
};

export const validateUsername = (username: string): boolean => {
  return registerSchema.shape.username.safeParse(username).success;
};
