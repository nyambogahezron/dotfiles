'use client';

import React, { useState } from 'react';
import { DragEndEvent, DndContext, closestCorners } from '@dnd-kit/core';
import KanbanColumn from '@/components/Kanban/KanbanColumn';
import useProjectStore from '@/store/useProjectStore';
import { handleDragEnd, KANBAN_COLUMNS } from '@/utils/dragAndDrop';

interface KanbanBoardProps {
  projectId: string;
}

export default function KanbanBoard({ projectId }: KanbanBoardProps) {
  const moveTask = useProjectStore((state) => state.moveTask);

  if (!projectId) return null;

  const onDragEnd = (event: DragEndEvent) => {
    handleDragEnd(event, (taskId, newStatus) => {
      moveTask(taskId, newStatus);
    });
  };

  return (
    <DndContext onDragEnd={onDragEnd} collisionDetection={closestCorners}>
      <div className="flex-1 p-6 bg-slate-900">
        <div className="flex space-x-4 h-full">
          {KANBAN_COLUMNS.map((column, index) => (
            <KanbanColumn
              key={column.id}
              title={column.title}
              projectId={projectId}
              status={column.status}
              columnId={column.id}
              description={getColumnDescription(column.status)}
              color={getColumnColor(index)}
            />
          ))}
        </div>
      </div>
    </DndContext>
  );
}

// Helper functions for column configuration
const getColumnDescription = (status: string) => {
  switch (status) {
    case 'Todo':
      return "This item hasn't been started";
    case 'In Progress':
      return 'This is actively being worked on';
    case 'Done':
      return 'This has been completed';
    case 'Next Version':
      return 'This is the next version to be worked on';
    default:
      return '';
  }
};

const getColumnColor = (
  index: number
): 'green' | 'yellow' | 'purple' | 'slate' => {
  const colors: ('green' | 'yellow' | 'purple' | 'slate')[] = [
    'green',
    'yellow',
    'purple',
    'green',
  ];
  return colors[index] || 'slate';
};
