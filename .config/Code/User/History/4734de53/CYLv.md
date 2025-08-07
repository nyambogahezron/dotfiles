# Shared Packages

This directory contains shared code that can be used across multiple applications in the TaskFlow monorepo, except for mobile-specific functionality.

## Packages Overview

### @taskflow/shared-types
Common TypeScript types and interfaces used across the application.

**Features:**
- User, Task, Project interfaces
- API response types
- Socket event types
- Form types
- Configuration types

**Usage:**
```typescript
import { User, Task, TaskStatus, ApiResponse } from '@taskflow/shared-types';
```

### @taskflow/shared-utils
Common utility functions for data manipulation, validation, and formatting.

**Features:**
- Date utilities (formatDate, isDateOverdue, getRelativeTime)
- String utilities (truncateText, slugify, capitalize)
- Array utilities (groupBy, sortBy, uniqueBy)
- Object utilities (pick, omit, isEmpty)
- Validation utilities (isValidEmail, isStrongPassword)
- API utilities (createApiResponse, handleApiError)
- Task utilities (getTaskStatusColor, sortTasksByPriority)
- Local storage utilities
- Debounce and throttle functions

**Usage:**
```typescript
import { formatDate, groupBy, isValidEmail, debounce } from '@taskflow/shared-utils';
```

### @taskflow/shared-ui
Common React UI components for web and desktop applications.

**Important:** These components are designed for React web apps and should NOT be used in React Native/mobile apps.

**Features:**
- Button, Input, Card, Badge components
- Modal, LoadingSpinner, EmptyState components
- TaskCard component for displaying tasks

**Usage:**
```typescript
import { Button, Input, Card, TaskCard } from '@taskflow/shared-ui';
```

### @taskflow/shared-hooks
Common React hooks for state management and side effects.

**Features:**
- useLocalStorage - Persistent local storage state
- useDebounce - Debounced values
- useToggle - Boolean state toggle
- usePrevious - Previous value tracking
- useAsync - Async operation state management
- useClickOutside - Click outside detection
- useWindowSize - Window size tracking
- useOnlineStatus - Online/offline status
- useInterval - Interval management
- useCopyToClipboard - Clipboard operations

**Usage:**
```typescript
import { useLocalStorage, useDebounce, useAsync } from '@taskflow/shared-hooks';
```

### @taskflow/shared-validations
Common validation schemas using Zod for form validation and API data validation.

**Features:**
- User validation (login, register, profile update)
- Task validation (create, update, filters)
- Project validation (create, update)
- Search and pagination schemas
- Helper validation functions

**Usage:**
```typescript
import { loginSchema, createTaskSchema, validateEmail } from '@taskflow/shared-validations';
```

## Applications Using Shared Packages

### ✅ Web App (`apps/web`)
Can use all shared packages

### ✅ Desktop UI (`apps/desktop-ui`)
Can use all shared packages

### ✅ Server (`apps/server`)
Can use: shared-types, shared-utils, shared-validations

### ❌ Mobile App (`apps/mobile`)
Should NOT use shared-ui (React Native incompatible)
Can use: shared-types, shared-utils, shared-validations, shared-hooks (with React Native compatibility considerations)

## Building Shared Packages

To build all shared packages:
```bash
nx run-many --target=build --projects=shared-types,shared-utils,shared-ui,shared-hooks,shared-validations
```

To build a specific package:
```bash
nx build shared-types
nx build shared-utils
nx build shared-ui
nx build shared-hooks
nx build shared-validations
```

## Development Workflow

1. **Add new shared functionality** to the appropriate package
2. **Build the package** to generate types and distribution files
3. **Import and use** in your application
4. **Test across applications** to ensure compatibility

## Package Dependencies

```
shared-types (base package)
├── shared-utils (depends on shared-types)
├── shared-ui (depends on shared-types, shared-utils)
├── shared-hooks (depends on shared-types, shared-utils)
└── shared-validations (depends on shared-types)
```

## Adding New Shared Code

When adding new shared functionality:

1. **Determine the right package:**
   - Types/interfaces → shared-types
   - Utility functions → shared-utils
   - React components (web only) → shared-ui
   - React hooks → shared-hooks
   - Validation schemas → shared-validations

2. **Consider mobile compatibility:**
   - If it should work on mobile, avoid using shared-ui
   - Ensure React Native compatibility for hooks and utils

3. **Update dependencies:**
   - Add internal package dependencies in package.json
   - Update tsconfig.json paths if needed

4. **Document the changes:**
   - Update this README
   - Add JSDoc comments to your code
   - Include usage examples

## Best Practices

- **Keep packages focused:** Each package should have a single responsibility
- **Avoid circular dependencies:** shared-types should not depend on other packages
- **Mobile-first thinking:** Consider React Native compatibility when adding utilities
- **Type safety:** Always provide proper TypeScript types
- **Testing:** Add tests for shared utilities and components
- **Documentation:** Keep this README updated with new features
