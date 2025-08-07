export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  role: 'admin' | 'manager' | 'member';
}

export interface Project {
  id: string;
  name: string;
  description: string;
  color: string;
  startDate: string;
  endDate: string;
  status: 'Planning' | 'Active' | 'On Hold' | 'Completed';
  ownerId: string;
  teamMembers: string[];
  milestones: Milestone[];
  createdAt: string;
  progress: number;
  budget: number;
  client: string;
  isPrivate: boolean;
  lastUpdated: string;
}

export interface Milestone {
  id: string;
  title: string;
  description: string;
  dueDate: string;
  completed: boolean;
  projectId: string;
}

export interface Comment {
  id: string;
  taskId: string;
  userId: string;
  content: string;
  createdAt: string;
  updatedAt?: string;
}

export interface Attachment {
  id: string;
  name: string;
  url: string;
  type: string;
  size: number;
  uploadedBy: string;
  uploadedAt: string;
}

export interface Notification {
  id: string;
  userId: string;
  type:
    | 'task_assigned'
    | 'task_updated'
    | 'comment_added'
    | 'deadline_approaching';
  title: string;
  message: string;
  read: boolean;
  createdAt: string;
  relatedId?: string;
}

export type ViewMode =
  | 'dashboard'
  | 'tasks'
  | 'calendar'
  | 'kanban'
  | 'timeline';

export interface FilterOptions {
  project?: string;
  priority?: string;
  status?: string;
  assignee?: string;
  dueDate?: string;
  search?: string;
}

export interface TeamMember {
  id: string;
  name: string;
  email: string;
  avatar: string;
  role: string;
  capacity: number;
  allocated: number;
  projectId: string;
}

export interface Task {
  id: string;
  title: string;
  description: string;
  status: 'Todo' | 'In Progress' | 'Done' | 'Next Version';
  priority: 'High' | 'Medium' | 'Low';
  assigneeId: string;
  projectId: string;
  estimate: number;
  completed: number;
  dueDate: string;
  labels: string[];
  createdAt: string;
  updatedAt: string;
}

export interface Milestone {
  id: string;
  name: string;
  description: string;
  dueDate: string;
  completed: boolean;
  projectId: string;
  quarterlyGoalId: string;
}

export interface QuarterlyGoal {
  id: string;
  title: string;
  description: string;
  status: 'completed' | 'in-progress' | 'planned';
  startDate: string;
  endDate: string;
  progress: number;
  projectId: string;
  milestones: Milestone[];
}

export interface Iteration {
  id: string;
  name: string;
  startDate: string;
  endDate: string;
  projectId: string;
  tasks: string[]; // Task IDs
  isActive: boolean;
}

export interface CustomView {
  id: string;
  name: string;
  type: 'board' | 'table' | 'timeline' | 'chart';
  projectId: string;
  config: Record<string, unknown>;
  createdAt: string;
}

export interface CreateProjectData {
  name: string;
  description: string;
  isPrivate: boolean;
}

export interface CreateTaskData {
  title: string;
  description: string;
  status: 'Todo' | 'In Progress' | 'Done' | 'Next Version';
  priority: 'High' | 'Medium' | 'Low';
  assigneeId: string;
  estimate: number;
  dueDate: string;
  labels: string[];
}

export interface CreateTeamMemberData {
  name: string;
  email: string;
  role: string;
  capacity: number;
}

export interface CreateMilestoneData {
  name: string;
  description: string;
  dueDate: string;
  quarterlyGoalId: string;
}

export interface CreateIterationData {
  name: string;
  startDate: string;
  endDate: string;
  taskIds: string[];
}
