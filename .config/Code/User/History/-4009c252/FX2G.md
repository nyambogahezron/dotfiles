# Project Tracking System

This document explains the project tracking system implementation that ensures proper project ID tracking across all routes in the Task Flow application.

## Problem Solved

Previously, when navigating to project routes like `/project/default/chats`, the application wasn't properly tracking which project was currently being viewed. This led to inconsistent state management and potential data loss when switching between different project sections.

## Solution Components

### 1. Custom Hook: `useProjectId`

**Location:** `src/hooks/useProjectId.ts`

This hook:

- Extracts the `projectId` from URL parameters using Next.js `useParams()`
- Synchronizes the URL project ID with the global Zustand store
- Returns both the `projectId` and a validation flag `isValidProject`

```typescript
const { projectId, isValidProject } = useProjectId();
```

### 2. Project Context Provider

**Location:** `src/contexts/ProjectContext.tsx`

Provides project-related data throughout the project route tree:

- Current project ID
- Project validation status
- Current project data from the store

```typescript
const { projectId, currentProject, isValidProject } = useProjectContext();
```

### 3. Updated Project Layout

**Location:** `src/app/project/[projectId]/layout.tsx`

- Uses the `useProjectId` hook to track the current project
- Wraps children with `ProjectProvider` for context access
- Handles invalid projects gracefully

### 4. Enhanced Store Integration

**Location:** `src/store/useProjectStore.ts`

- Added a "default" project to the initial state
- The store's `currentProjectId` is automatically synced with URL changes

## Usage in Project Pages

### For New Pages

When creating new pages under `/project/[projectId]/`, use this pattern:

```typescript
'use client';

import React from 'react';
import { useProjectContext } from '@/contexts/ProjectContext';

export default function YourPage() {
  const { projectId, currentProject, isValidProject } = useProjectContext();

  if (!isValidProject) {
    return <div>Invalid project</div>;
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold text-white mb-4">
        Your Page - {currentProject?.name || `Project ${projectId}`}
      </h1>
      <div className="text-slate-300">
        <p>Current Project ID: {projectId}</p>
        <p>Project Name: {currentProject?.name}</p>
        {/* Your page content here */}
      </div>
    </div>
  );
}
```

### For Existing Pages

1. Add `'use client';` directive if not present
2. Import and use `useProjectContext()`
3. Access `projectId` and `currentProject` from the context
4. Remove any manual `useParams()` calls for project ID

## Available Projects

The store now includes these default projects:

- **default** - Default Project (ID: 'default')
- **untitled-project** - @nyambogahezron's untitled project
- **task-flow** - Task Flow
- **quizfy-app** - quizfy-app

## Benefits

1. **Consistent State**: Project ID is always synchronized between URL and store
2. **Easy Access**: Any component in the project route can access current project data
3. **Type Safety**: Proper TypeScript types for project data
4. **Error Handling**: Graceful handling of invalid project IDs
5. **Performance**: Minimal re-renders with efficient context usage

## Navigation

When navigating between project sections, the project ID is automatically maintained:

- `/project/default/` → Main project view
- `/project/default/chats` → Chats for the default project
- `/project/default/team-capacity` → Team capacity for the default project
- etc.

The system ensures that the current project context is preserved across all these routes.
