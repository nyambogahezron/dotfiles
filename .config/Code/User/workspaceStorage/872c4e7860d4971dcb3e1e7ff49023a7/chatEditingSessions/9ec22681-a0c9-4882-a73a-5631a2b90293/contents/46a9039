import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';
import { v4 as uuidv4 } from 'uuid';
import {
  Project,
  Task,
  TeamMember,
  QuarterlyGoal,
  Milestone,
  Iteration,
  CustomView,
  CreateProjectData,
  CreateTaskData,
  CreateTeamMemberData,
  CreateMilestoneData,
  CreateIterationData,
} from '../types';

interface ProjectState {
  // State
  projects: Project[];
  tasks: Task[];
  teamMembers: TeamMember[];
  quarterlyGoals: QuarterlyGoal[];
  milestones: Milestone[];
  iterations: Iteration[];
  customViews: CustomView[];
  currentProjectId: string | null;
  loading: boolean;
  error: string | null;

  // Project CRUD
  createProject: (data: CreateProjectData) => void;
  updateProject: (id: string, data: Partial<Project>) => void;
  deleteProject: (id: string) => void;
  setCurrentProject: (id: string) => void;

  // Task CRUD
  createTask: (projectId: string, data: CreateTaskData) => void;
  updateTask: (id: string, data: Partial<Task>) => void;
  deleteTask: (id: string) => void;
  moveTask: (id: string, newStatus: Task['status']) => void;

  // Team Member CRUD
  createTeamMember: (projectId: string, data: CreateTeamMemberData) => void;
  updateTeamMember: (id: string, data: Partial<TeamMember>) => void;
  deleteTeamMember: (id: string) => void;

  // Milestone CRUD
  createMilestone: (projectId: string, data: CreateMilestoneData) => void;
  updateMilestone: (id: string, data: Partial<Milestone>) => void;
  deleteMilestone: (id: string) => void;
  toggleMilestone: (id: string) => void;

  // Iteration CRUD
  createIteration: (projectId: string, data: CreateIterationData) => void;
  updateIteration: (id: string, data: Partial<Iteration>) => void;
  deleteIteration: (id: string) => void;
  setActiveIteration: (id: string) => void;

  // Custom View CRUD
  createCustomView: (
    projectId: string,
    name: string,
    type: CustomView['type']
  ) => void;
  updateCustomView: (id: string, data: Partial<CustomView>) => void;
  deleteCustomView: (id: string) => void;

  // Getters
  getCurrentProject: () => Project | null;
  getProjectTasks: (projectId: string) => Task[];
  getProjectTeamMembers: (projectId: string) => TeamMember[];
  getProjectQuarterlyGoals: (projectId: string) => QuarterlyGoal[];
  getProjectIterations: (projectId: string) => Iteration[];
  getActiveIteration: (projectId: string) => Iteration | null;
  getUserTasks: (userId: string) => Task[];
  getTasksByStatus: (projectId: string, status: Task['status']) => Task[];
}

const useProjectStore = create<ProjectState>()(
  devtools(
    persist(
      (set, get) => ({
        // Initial State
        projects: [
          {
            id: 'default',
            name: 'Default Project',
            description: 'Default project for task management',
            isPrivate: false,
            lastUpdated: 'just now',
            projectNumber: '#1',
            createdAt: new Date().toISOString(),
            ownerId: 'nyambogahezron',
            color: '#6366F1',
            startDate: '2024-01-01',
            endDate: '2024-12-31',
            status: 'Active',
            budget: 0,
            client: '',
          },
          {
            id: 'untitled-project',
            name: "@nyambogahezron's untitled project",
            description: 'A new project to explore ideas',
            isPrivate: true,
            lastUpdated: '8 minutes ago',
            projectNumber: '#4',
            createdAt: new Date().toISOString(),
            ownerId: 'nyambogahezron',
            color: '#FFB300',
            startDate: '2024-04-01',
            endDate: '2024-06-30',
            status: 'Active',
            budget: 0,
            client: '',
          },
          {
            id: 'task-flow',
            name: 'Task Flow',
            description: 'Project management and task tracking system',
            isPrivate: true,
            lastUpdated: '3 days ago',
            projectNumber: '#3',
            createdAt: new Date().toISOString(),
            ownerId: 'nyambogahezron',
            color: '#1976D2',
            startDate: '2024-01-01',
            endDate: '2024-12-31',
            status: 'Active',
            budget: 0,
            client: '',
          },
          {
            id: 'quizfy-app',
            name: 'quizfy-app',
            description: 'Interactive quiz application',
            isPrivate: true,
            lastUpdated: 'on Apr 17',
            projectNumber: '#2',
            createdAt: new Date().toISOString(),
            ownerId: 'nyambogahezron',
            color: '#43A047',
            startDate: '2024-03-01',
            endDate: '2024-09-30',
            status: 'Active',
            budget: 0,
            client: '',
          },
        ],
        tasks: [
          {
            id: '1',
            title: 'Implement user authentication system',
            description: 'Set up secure login and registration system',
            status: 'In Progress',
            priority: 'High',
            assigneeId: 'nyambogahezron',
            projectId: 'task-flow',
            estimate: 8,
            completed: 5,
            dueDate: '2024-01-25',
            labels: ['backend', 'security'],
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
          },
          {
            id: '2',
            title: 'Design dashboard layout',
            description: 'Create responsive dashboard interface',
            status: 'Done',
            priority: 'Medium',
            assigneeId: 'sarah-chen',
            projectId: 'task-flow',
            estimate: 5,
            completed: 5,
            dueDate: '2024-01-20',
            labels: ['frontend', 'design'],
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
          },
        ],
        teamMembers: [
          {
            id: 'nyambogahezron',
            name: 'nyambogahezron',
            email: 'nyamboga@example.com',
            avatar:
              'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&fit=crop',
            role: 'Full Stack Developer',
            capacity: 40,
            allocated: 32,
            projectId: 'task-flow',
          },
          {
            id: 'sarah-chen',
            name: 'Sarah Chen',
            email: 'sarah@example.com',
            avatar:
              'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&fit=crop',
            role: 'UI/UX Designer',
            capacity: 40,
            allocated: 28,
            projectId: 'task-flow',
          },
        ],
        quarterlyGoals: [],
        milestones: [],
        iterations: [],
        customViews: [],
        currentProjectId: null,
        loading: false,
        error: null,

        // Project CRUD
        createProject: (data) =>
          set((state) => {
            const newProject: Project = {
              id: uuidv4(),
              ...data,
              lastUpdated: 'just now',
              projectNumber: `#${state.projects.length + 1}`,
              createdAt: new Date().toISOString(),
              ownerId: 'nyambogahezron',
            };
            return { projects: [...state.projects, newProject] };
          }),

        updateProject: (id, data) =>
          set((state) => ({
            projects: state.projects.map((project) =>
              project.id === id
                ? { ...project, ...data, lastUpdated: 'just now' }
                : project
            ),
          })),

        deleteProject: (id) =>
          set((state) => ({
            projects: state.projects.filter((project) => project.id !== id),
            tasks: state.tasks.filter((task) => task.projectId !== id),
            teamMembers: state.teamMembers.filter(
              (member) => member.projectId !== id
            ),
            currentProjectId:
              state.currentProjectId === id ? null : state.currentProjectId,
          })),

        setCurrentProject: (id) => set({ currentProjectId: id }),

        // Task CRUD
        createTask: (projectId, data) =>
          set((state) => {
            const newTask: Task = {
              id: uuidv4(),
              ...data,
              projectId,
              completed: 0,
              createdAt: new Date().toISOString(),
              updatedAt: new Date().toISOString(),
            };
            return { tasks: [...state.tasks, newTask] };
          }),

        updateTask: (id, data) =>
          set((state) => ({
            tasks: state.tasks.map((task) =>
              task.id === id
                ? { ...task, ...data, updatedAt: new Date().toISOString() }
                : task
            ),
          })),

        deleteTask: (id) =>
          set((state) => ({
            tasks: state.tasks.filter((task) => task.id !== id),
          })),

        moveTask: (id, newStatus) =>
          set((state) => {
            console.log(`Store: Moving task ${id} to ${newStatus}`); // Debug log
            const updatedTasks = state.tasks.map((task) =>
              task.id === id
                ? {
                    ...task,
                    status: newStatus,
                    updatedAt: new Date().toISOString(),
                  }
                : task
            );
            console.log(
              'Updated tasks:',
              updatedTasks.filter((t) => t.id === id)
            ); // Debug log
            return { tasks: updatedTasks };
          }),

        // Team Member CRUD
        createTeamMember: (projectId, data) =>
          set((state) => {
            const newMember: TeamMember = {
              id: uuidv4(),
              ...data,
              projectId,
              allocated: 0,
              avatar: `https://images.pexels.com/photos/${Math.floor(
                Math.random() * 1000000
              )}/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&fit=crop`,
            };
            return { teamMembers: [...state.teamMembers, newMember] };
          }),

        updateTeamMember: (id, data) =>
          set((state) => ({
            teamMembers: state.teamMembers.map((member) =>
              member.id === id ? { ...member, ...data } : member
            ),
          })),

        deleteTeamMember: (id) =>
          set((state) => ({
            teamMembers: state.teamMembers.filter((member) => member.id !== id),
          })),

        // Milestone CRUD
        createMilestone: (projectId, data) =>
          set((state) => {
            const newMilestone: Milestone = {
              id: uuidv4(),
              ...data,
              projectId,
              completed: false,
            };
            return { milestones: [...state.milestones, newMilestone] };
          }),

        updateMilestone: (id, data) =>
          set((state) => ({
            milestones: state.milestones.map((milestone) =>
              milestone.id === id ? { ...milestone, ...data } : milestone
            ),
          })),

        deleteMilestone: (id) =>
          set((state) => ({
            milestones: state.milestones.filter(
              (milestone) => milestone.id !== id
            ),
          })),

        toggleMilestone: (id) =>
          set((state) => ({
            milestones: state.milestones.map((milestone) =>
              milestone.id === id
                ? { ...milestone, completed: !milestone.completed }
                : milestone
            ),
          })),

        // Iteration CRUD
        createIteration: (projectId, data) =>
          set((state) => {
            const newIteration: Iteration = {
              id: uuidv4(),
              ...data,
              projectId,
              tasks: data.taskIds,
              isActive: false,
            };
            return { iterations: [...state.iterations, newIteration] };
          }),

        updateIteration: (id, data) =>
          set((state) => ({
            iterations: state.iterations.map((iteration) =>
              iteration.id === id ? { ...iteration, ...data } : iteration
            ),
          })),

        deleteIteration: (id) =>
          set((state) => ({
            iterations: state.iterations.filter(
              (iteration) => iteration.id !== id
            ),
          })),

        setActiveIteration: (id) =>
          set((state) => ({
            iterations: state.iterations.map((iteration) => ({
              ...iteration,
              isActive: iteration.id === id,
            })),
          })),

        // Custom View CRUD
        createCustomView: (projectId, name, type) =>
          set((state) => {
            const newView: CustomView = {
              id: uuidv4(),
              name,
              type,
              projectId,
              config: {},
              createdAt: new Date().toISOString(),
            };
            return { customViews: [...state.customViews, newView] };
          }),

        updateCustomView: (id, data) =>
          set((state) => ({
            customViews: state.customViews.map((view) =>
              view.id === id ? { ...view, ...data } : view
            ),
          })),

        deleteCustomView: (id) =>
          set((state) => ({
            customViews: state.customViews.filter((view) => view.id !== id),
          })),

        // Getters
        getCurrentProject: () => {
          const state = get();
          return (
            state.projects.find((p) => p.id === state.currentProjectId) || null
          );
        },

        getProjectTasks: (projectId) => {
          const state = get();
          return state.tasks.filter((task) => task.projectId === projectId);
        },

        getProjectTeamMembers: (projectId) => {
          const state = get();
          return state.teamMembers.filter(
            (member) => member.projectId === projectId
          );
        },

        getProjectQuarterlyGoals: (projectId) => {
          const state = get();
          return state.quarterlyGoals.filter(
            (goal) => goal.projectId === projectId
          );
        },

        getProjectIterations: (projectId) => {
          const state = get();
          return state.iterations.filter(
            (iteration) => iteration.projectId === projectId
          );
        },

        getActiveIteration: (projectId) => {
          const state = get();
          return (
            state.iterations.find(
              (iteration) =>
                iteration.projectId === projectId && iteration.isActive
            ) || null
          );
        },

        getUserTasks: (userId) => {
          const state = get();
          return state.tasks.filter((task) => task.assigneeId === userId);
        },

        getTasksByStatus: (projectId, status) => {
          const state = get();
          return state.tasks.filter(
            (task) => task.projectId === projectId && task.status === status
          );
        },
      }),
      {
        name: 'project-store',
        partialize: (state) => ({
          projects: state.projects,
          tasks: state.tasks,
          teamMembers: state.teamMembers,
          quarterlyGoals: state.quarterlyGoals,
          milestones: state.milestones,
          iterations: state.iterations,
          customViews: state.customViews,
        }),
      }
    ),
    { name: 'project-store' }
  )
);

export default useProjectStore;
