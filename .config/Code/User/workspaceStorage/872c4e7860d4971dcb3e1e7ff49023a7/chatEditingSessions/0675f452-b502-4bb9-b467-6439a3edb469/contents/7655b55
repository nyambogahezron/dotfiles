/**
 * Drag and drop utilities for Kanban board using react-beautiful-dnd
 */

import { DropResult } from 'react-beautiful-dnd';

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
  result: DropResult,
  onTaskMove: (
    taskId: string,
    newStatus: 'Todo' | 'In Progress' | 'Done' | 'Next Version'
  ) => void
) => {
  const { destination, source, draggableId } = result;

  // If dropped outside any droppable area
  if (!destination) {
    return;
  }

  // If dropped in the same position
  if (
    destination.droppableId === source.droppableId &&
    destination.index === source.index
  ) {
    return;
  }

  // Find the target column
  const targetColumn = KANBAN_COLUMNS.find(
    (col) => col.id === destination.droppableId
  );

  if (targetColumn) {
    // Extract task ID from draggableId (format: "task-{taskId}")
    const taskId = draggableId.replace('task-', '');
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
