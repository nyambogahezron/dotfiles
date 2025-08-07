'use client';

import React from 'react';
import { useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';

interface Task {
  id: string;
  title: string;
  priority: 'High' | 'Medium' | 'Low';
  completed: number;
  estimate: number;
  assigneeId?: string;
}

interface TeamMember {
  id: string;
  name: string;
}

interface DragItemProps {
  task: Task;
  assignee?: TeamMember;
}

export default function DragItem({ task, assignee }: DragItemProps) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: `task-${task.id}` });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
      className={`bg-slate-800 border border-slate-600 rounded-lg p-3 hover:bg-slate-700 transition-colors cursor-grab active:cursor-grabbing ${
        isDragging ? 'opacity-75 transform rotate-2 shadow-lg' : ''
      }`}
    >
      <h4 className="text-white font-medium text-sm mb-2">{task.title}</h4>
      <div className="flex items-center justify-between text-xs text-slate-400">
        <span>{assignee?.name || 'Unassigned'}</span>
        <span
          className={`px-2 py-1 rounded-full ${
            task.priority === 'High'
              ? 'bg-red-500/20 text-red-400'
              : task.priority === 'Medium'
              ? 'bg-yellow-500/20 text-yellow-400'
              : 'bg-green-500/20 text-green-400'
          }`}
        >
          {task.priority}
        </span>
      </div>
      <div className="mt-2">
        <div className="bg-slate-700 rounded-full h-1">
          <div
            className="bg-blue-500 h-1 rounded-full"
            style={{
              width: `${(task.completed / task.estimate) * 100}%`,
            }}
          />
        </div>
      </div>
    </div>
  );
}
