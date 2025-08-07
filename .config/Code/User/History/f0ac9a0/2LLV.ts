// Common types used across multiple applications

// User related types
export interface User {
  id: string;
  email: string;
  username: string;
  firstName?: string;
  lastName?: string;
  avatar?: string;
  createdAt: Date;
  updatedAt: Date;
}

// Task related types
export interface Task {
  id: string;
  title: string;
  description?: string;
  status: TaskStatus;
  priority: TaskPriority;
  assigneeId?: string;
  projectId?: string;
  dueDate?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export enum TaskStatus {
  TODO = 'todo',
  IN_PROGRESS = 'in_progress',
  REVIEW = 'review',
  DONE = 'done',
}

export enum TaskPriority {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
  URGENT = 'urgent',
}

// Project related types
export interface Project {
  id: string;
  name: string;
  description?: string;
  ownerId: string;
  members: string[];
  createdAt: Date;
  updatedAt: Date;
}

// API Response types
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Common form types
export interface LoginForm {
  email: string;
  password: string;
}

export interface RegisterForm {
  email: string;
  username: string;
  password: string;
  confirmPassword: string;
  firstName?: string;
  lastName?: string;
}

// Socket events
export interface SocketEvents {
  // Task events
  'task:created': Task;
  'task:updated': Task;
  'task:deleted': { id: string };

  // User events
  'user:online': { userId: string };
  'user:offline': { userId: string };

  // Project events
  'project:updated': Project;
  'project:member-added': { projectId: string; userId: string };
  'project:member-removed': { projectId: string; userId: string };
}

// Configuration types
export interface AppConfig {
  apiUrl: string;
  wsUrl: string;
  environment: 'development' | 'production' | 'test';
  features: {
    notifications: boolean;
    realtime: boolean;
    analytics: boolean;
  };
}
