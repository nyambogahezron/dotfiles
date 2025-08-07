'use client';

import React, { useState } from 'react';
import { DragEndEvent, DndContext, closestCorners } from '@dnd-kit/core';
import KanbanColumn from '@/components/Kanban/KanbanColumn';
import MobileKanbanColumn from '@/components/Kanban/MobileKanbanColumn';
import useProjectStore from '@/store/useProjectStore';
import { handleDragEnd, KANBAN_COLUMNS } from '@/utils/dragAndDrop';

interface KanbanBoardProps {
  projectId: string;
}

export default function KanbanBoard({ projectId }: KanbanBoardProps) {
  const moveTask = useProjectStore((state) => state.moveTask);
  const [activeTab, setActiveTab] = useState(0);

  if (!projectId) return null;

  const onDragEnd = (event: DragEndEvent) => {
    handleDragEnd(event, (taskId, newStatus) => {
      moveTask(taskId, newStatus);
    });
  };

  return (
    <>
      {/* Mobile Tab View */}
      <div className="block lg:hidden">
        <div className="flex-1 p-4 bg-slate-900">
          {/* Tab Headers */}
          <div className="flex space-x-1 mb-4 bg-slate-800 p-1 rounded-lg">
            {KANBAN_COLUMNS.map((column, index) => (
              <button
                key={column.id}
                onClick={() => setActiveTab(index)}
                className={`flex-1 py-2 px-3 text-sm font-medium rounded-md transition-colors ${
                  activeTab === index
                    ? 'bg-slate-700 text-white'
                    : 'text-slate-400 hover:text-slate-300'
                }`}
              >
                {column.title}
              </button>
            ))}
          </div>

          {/* Active Tab Content */}
          <div className="min-h-[500px]">
            <MobileKanbanColumn
              title={KANBAN_COLUMNS[activeTab].title}
              projectId={projectId}
              status={KANBAN_COLUMNS[activeTab].status}
              columnId={KANBAN_COLUMNS[activeTab].id}
              description={getColumnDescription(KANBAN_COLUMNS[activeTab].status)}
              color={getColumnColor(activeTab)}
            />
          </div>
        </div>
      </div>

      {/* Desktop Drag & Drop View */}
      <div className="hidden lg:block">
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
      </div>
    </>
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
