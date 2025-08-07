# Integration Examples

## Web App Integration (`apps/web`)

### package.json additions:

```json
{
  "dependencies": {
    "@taskflow/shared-types": "workspace:*",
    "@taskflow/shared-utils": "workspace:*",
    "@taskflow/shared-ui": "workspace:*",
    "@taskflow/shared-hooks": "workspace:*",
    "@taskflow/shared-validations": "workspace:*"
  }
}
```

### Example component using shared packages:

```typescript
// apps/web/src/components/TaskList.tsx
import React from 'react';
import { Task } from '@taskflow/shared-types';
import { TaskCard, LoadingSpinner, EmptyState } from '@taskflow/shared-ui';
import { useAsync, useLocalStorage } from '@taskflow/shared-hooks';
import { sortTasksByPriority } from '@taskflow/shared-utils';

interface TaskListProps {
  projectId?: string;
}

export const TaskList: React.FC<TaskListProps> = ({ projectId }) => {
  const [viewMode, setViewMode] = useLocalStorage('taskViewMode', 'grid');

  const {
    data: tasks,
    loading,
    error,
  } = useAsync(async () => {
    const response = await fetch(
      `/api/tasks${projectId ? `?projectId=${projectId}` : ''}`
    );
    return response.json();
  });

  if (loading) return <LoadingSpinner />;
  if (error) return <div>Error: {error}</div>;
  if (!tasks?.length) {
    return (
      <EmptyState
        title="No tasks found"
        description="Create your first task to get started"
        action={{
          label: 'Create Task',
          onClick: () => console.log('Create task clicked'),
        }}
      />
    );
  }

  const sortedTasks = sortTasksByPriority(tasks);

  return (
    <div
      className={`grid gap-4 ${
        viewMode === 'grid'
          ? 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3'
          : 'grid-cols-1'
      }`}
    >
      {sortedTasks.map((task: Task) => (
        <TaskCard
          key={task.id}
          task={task}
          onClick={(task) => console.log('Task clicked:', task)}
        />
      ))}
    </div>
  );
};
```

## Desktop App Integration (`apps/desktop-ui`)

### tsconfig.json updates:

```json
{
  "compilerOptions": {
    "paths": {
      "@taskflow/shared-types": ["../../packages/shared-types/src"],
      "@taskflow/shared-utils": ["../../packages/shared-utils/src"],
      "@taskflow/shared-ui": ["../../packages/shared-ui/src"],
      "@taskflow/shared-hooks": ["../../packages/shared-hooks/src"],
      "@taskflow/shared-validations": ["../../packages/shared-validations/src"]
    }
  }
}
```

### Example form component:

```typescript
// apps/desktop-ui/src/components/CreateTaskForm.tsx
import React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { Button, Input, Card } from '@taskflow/shared-ui';
import {
  createTaskSchema,
  CreateTaskFormData,
} from '@taskflow/shared-validations';
import { TaskPriority, TaskStatus } from '@taskflow/shared-types';

export const CreateTaskForm: React.FC = () => {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<CreateTaskFormData>({
    resolver: zodResolver(createTaskSchema),
    defaultValues: {
      status: TaskStatus.TODO,
      priority: TaskPriority.MEDIUM,
    },
  });

  const onSubmit = async (data: CreateTaskFormData) => {
    try {
      const response = await fetch('/api/tasks', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        console.log('Task created successfully');
      }
    } catch (error) {
      console.error('Failed to create task:', error);
    }
  };

  return (
    <Card title="Create New Task">
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <Input
          label="Task Title"
          {...register('title')}
          error={errors.title?.message}
        />

        <Input
          label="Description"
          {...register('description')}
          error={errors.description?.message}
          as="textarea"
          rows={3}
        />

        <div className="flex gap-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Priority
            </label>
            <select
              {...register('priority')}
              className="w-full px-3 py-2 border rounded-md"
            >
              <option value={TaskPriority.LOW}>Low</option>
              <option value={TaskPriority.MEDIUM}>Medium</option>
              <option value={TaskPriority.HIGH}>High</option>
              <option value={TaskPriority.URGENT}>Urgent</option>
            </select>
          </div>

          <div className="flex-1">
            <Input
              label="Due Date"
              type="datetime-local"
              {...register('dueDate')}
              error={errors.dueDate?.message}
            />
          </div>
        </div>

        <div className="flex gap-2">
          <Button type="submit" loading={isSubmitting}>
            Create Task
          </Button>
          <Button type="button" variant="outline">
            Cancel
          </Button>
        </div>
      </form>
    </Card>
  );
};
```

## Server Integration (`apps/server`)

### Example API endpoint using shared packages:

```typescript
// apps/server/src/controllers/taskController.ts
import { Request, Response } from 'express';
import { createTaskSchema, taskFilterSchema } from '@taskflow/shared-validations';
import { createApiResponse, handleApiError } from '@taskflow/shared-utils';
import { Task, ApiResponse } from '@taskflow/shared-types';

export const createTask = async (req: Request, res: Response): Promise<void> => {
  try {
    // Validate request body
    const validatedData = createTaskSchema.parse(req.body);

    // Create task in database
    const task: Task = {
      id: generateUUID(),
      ...validatedData,
      createdAt: new Date(),
      updatedAt: new Date()
    };

    // Save to database (pseudo code)
    await db.tasks.create(task);

    const response: ApiResponse<Task> = createApiResponse(true, task, 'Task created successfully');
    res.status(201).json(response);
  } catch (error) {
    const errorMessage = handleApiError(error);
    const response: ApiResponse = createApiResponse(false, undefined, undefined, errorMessage);
    res.status(400).json(response);
  }
};

export const getTasks = async (req: Request, res: Response): Promise<void> => {
  try {
    // Validate query parameters
    const filters = taskFilterSchema.parse(req.query);

    // Fetch tasks from database with filters
    const tasks = await db.tasks.findMany({
      where: {
        ...(filters.status && { status: filters.status }),
        ...(filters.priority && { priority: filters.priority }),
        ...(filters.projectId && { projectId: filters.projectId }),
      },
      limit: filters.limit,
      offset: (filters.page - 1) * filters.limit,
      orderBy: { [filters.sortBy || 'createdAt']: filters.sortOrder }
    });

    const total = await db.tasks.count({ where: /* same filters */ });

    const response = {
      success: true,
      data: tasks,
      pagination: {
        page: filters.page,
        limit: filters.limit,
        total,
        totalPages: Math.ceil(total / filters.limit)
      }
    };

    res.json(response);
  } catch (error) {
    const errorMessage = handleApiError(error);
    const response: ApiResponse = createApiResponse(false, undefined, undefined, errorMessage);
    res.status(400).json(response);
  }
};
```

## Mobile App Integration (`apps/mobile`) - Limited Usage

**⚠️ Important:** Mobile app should NOT use `@taskflow/shared-ui` as these components are not React Native compatible.

### Safe packages for mobile:

```typescript
// Mobile-safe imports
import { Task, User, TaskStatus } from '@taskflow/shared-types';
import { formatDate, isValidEmail, groupBy } from '@taskflow/shared-utils';
import { loginSchema, validateEmail } from '@taskflow/shared-validations';
// Note: shared-hooks might need React Native compatibility checks
```

### Example mobile screen:

```typescript
// apps/mobile/src/screens/TaskListScreen.tsx
import React from 'react';
import { View, Text, FlatList } from 'react-native';
import { Task } from '@taskflow/shared-types';
import { formatDate, sortTasksByPriority } from '@taskflow/shared-utils';
import { useLocalStorage } from '@taskflow/shared-hooks'; // Use with caution

export const TaskListScreen: React.FC = () => {
  const [tasks, setTasks] = useLocalStorage<Task[]>('tasks', []);

  const sortedTasks = sortTasksByPriority(tasks);

  const renderTask = ({ item }: { item: Task }) => (
    <View style={{ padding: 16, borderBottomWidth: 1 }}>
      <Text style={{ fontSize: 16, fontWeight: 'bold' }}>{item.title}</Text>
      <Text style={{ color: 'gray', marginTop: 4 }}>
        Created: {formatDate(item.createdAt)}
      </Text>
      <Text style={{ color: 'blue', marginTop: 4 }}>
        {item.status} • {item.priority}
      </Text>
    </View>
  );

  return (
    <FlatList
      data={sortedTasks}
      renderItem={renderTask}
      keyExtractor={(item) => item.id}
    />
  );
};
```

## Building and Running

1. **Build shared packages first:**

```bash
nx run-many --target=build --projects=shared-types,shared-utils,shared-validations,shared-hooks,shared-ui
```

2. **Run your applications:**

```bash
# Web app
nx serve web

# Desktop UI
nx serve desktop-ui

# Server
nx serve server

# Mobile (if using Expo)
nx start mobile
```

## Tips for Integration

1. **Always build shared packages first** before running applications that depend on them
2. **Use TypeScript path mapping** in each app's tsconfig.json for better development experience
3. **Import only what you need** to keep bundle sizes small
4. **Test cross-platform compatibility** especially when adding new utilities
5. **Update package.json dependencies** when adding new shared package usage
