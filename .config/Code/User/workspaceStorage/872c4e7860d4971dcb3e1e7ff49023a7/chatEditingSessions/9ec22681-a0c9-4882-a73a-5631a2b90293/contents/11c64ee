/**
 * Drag and drop utilities for Kanban board using @dnd-kit/core
 */

import { DragEndEvent } from '@dnd-kit/core';

export interface KanbanColumn {
  id: string;
  title: string;
  status: 'Todo' | 'In Progress' | 'Done' | 'Next Version';
}

export const KANBAN_COLUMNS: KanbanColumn[] = [
  { id: 'todo', title: 'Todo', status: 'Todo' },
  { id: 'in-progress', title: 'In Progress', status: 'In Progress' },
  { id: 'done', title: 'Done', status: 'Done' },
  { id: 'next-version', title: 'Next Version', status: 'Next Version' },
];

export const handleDragEnd = (
  event: DragEndEvent,
  onTaskMove: (
    taskId: string,
    newStatus: 'Todo' | 'In Progress' | 'Done' | 'Next Version'
  ) => void
) => {
  const { active, over } = event;

  console.log('Drag end event:', event); // Debug log

  // If dropped outside any droppable area
  if (!over) {
    console.log('No drop target - drag cancelled');
    return;
  }

  // If dropped in the same position
  if (active.id === over.id) {
    console.log('Same position - no change needed');
    return;
  }

  // Find the target column
  const targetColumn = KANBAN_COLUMNS.find((col) => col.id === over.id);

  if (targetColumn) {
    // Extract task ID from active.id (format: "task-{taskId}")
    const taskId = active.id.toString().replace('task-', '');
    console.log(`Moving task ${taskId} to ${targetColumn.status}`); // Debug log
    onTaskMove(taskId, targetColumn.status);
  }
};

// Helper function to get column ID from status
export const getColumnIdFromStatus = (
  status: 'Todo' | 'In Progress' | 'Done' | 'Next Version'
): string => {
  const column = KANBAN_COLUMNS.find((col) => col.status === status);
  return column?.id || 'todo';
};

// Helper function to get status from column ID
export const getStatusFromColumnId = (
  columnId: string
): 'Todo' | 'In Progress' | 'Done' | 'Next Version' => {
  const column = KANBAN_COLUMNS.find((col) => col.id === columnId);
  return column?.status || 'Todo';
};
