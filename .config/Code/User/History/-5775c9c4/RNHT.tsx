'use client';

import React from 'react';
import { useState } from 'react';
import { Droppable, Draggable } from 'react-beautiful-dnd';
import { Plus, MoreHorizontal, Circle } from 'lucide-react';
import CreateTaskForm from '../forms/CreateTaskForm';
import useProjectStore from '@/store/useProjectStore';

interface KanbanColumnProps {
  title: string;
  projectId: string;
  status: 'Todo' | 'In Progress' | 'Done' | 'Next Version';
  columnId: string;
  description: string;
  color: 'green' | 'yellow' | 'purple' | 'slate';
}

export default function KanbanColumn({
  title,
  projectId,
  status,
  columnId,
  description,
  color,
}: KanbanColumnProps) {
  const [showCreateTask, setShowCreateTask] = useState(false);
  const allTasks = useProjectStore((state) => state.tasks);
  const allTeamMembers = useProjectStore((state) => state.teamMembers);

  const tasks = allTasks.filter(
    (task) => task.projectId === projectId && task.status === status
  );
  const teamMembers = allTeamMembers.filter(
    (member) => member.projectId === projectId
  );

  const count = tasks.length;
  const estimate = tasks.reduce((sum, task) => sum + task.estimate, 0);

  const getColorClasses = () => {
    switch (color) {
      case 'green':
        return {
          icon: 'text-green-500',
          border: 'border-green-500/20',
          bg: 'bg-green-500/5',
        };
      case 'yellow':
        return {
          icon: 'text-yellow-500',
          border: 'border-yellow-500/20',
          bg: 'bg-yellow-500/5',
        };
      case 'purple':
        return {
          icon: 'text-purple-500',
          border: 'border-purple-500/20',
          bg: 'bg-purple-500/5',
        };
      case 'slate':
        return {
          icon: 'text-slate-500',
          border: 'border-slate-500/20',
          bg: 'bg-slate-500/5',
        };
      default:
        return {
          icon: 'text-slate-500',
          border: 'border-slate-500/20',
          bg: 'bg-slate-500/5',
        };
    }
  };

  const colorClasses = getColorClasses();

  return (
    <div className="flex-1 min-w-0">
      {/* Column Header */}
      <div
        className={`p-4 border-2 border-dashed ${colorClasses.border} ${colorClasses.bg} rounded-t-lg`}
      >
        <div className="flex items-center justify-between mb-2">
          <div className="flex items-center space-x-2">
            <Circle className={`w-4 h-4 ${colorClasses.icon} fill-current`} />
            <span className="font-medium text-white">{title}</span>
            <span className="text-slate-400 text-sm">
              {count} / {estimate}
            </span>
            <span className="text-slate-500 text-sm">Estimate: {estimate}</span>
          </div>
          <button className="text-slate-400 hover:text-slate-300 transition-colors">
            <MoreHorizontal className="w-4 h-4" />
          </button>
        </div>
        <p className="text-sm text-slate-400">{description}</p>
      </div>

      {/* Column Content */}
      <Droppable droppableId={columnId}>
        {(provided, snapshot) => (
          <div
            ref={provided.innerRef}
            {...provided.droppableProps}
            className={`min-h-96 border-l-2 border-r-2 border-dashed ${
              colorClasses.border
            } ${colorClasses.bg} px-4 py-2 ${
              snapshot.isDraggingOver ? 'bg-slate-700/50' : ''
            }`}
          >
            {/* Task Items */}
            <div className="space-y-3 mb-4">
              {tasks.map((task, index) => {
                const assignee = teamMembers.find(
                  (member) => member.id === task.assigneeId
                );
                return (
                  <Draggable
                    key={task.id}
                    draggableId={`task-${task.id}`}
                    index={index}
                  >
                    {(provided, snapshot) => (
                      <div
                        ref={provided.innerRef}
                        {...provided.draggableProps}
                        {...provided.dragHandleProps}
                        className={`bg-slate-800 border border-slate-600 rounded-lg p-3 hover:bg-slate-700 transition-colors ${
                          snapshot.isDragging
                            ? 'opacity-75 transform rotate-2 shadow-lg'
                            : ''
                        }`}
                      >
                        <h4 className="text-white font-medium text-sm mb-2">
                          {task.title}
                        </h4>
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
                                width: `${
                                  (task.completed / task.estimate) * 100
                                }%`,
                              }}
                            />
                          </div>
                        </div>
                      </div>
                    )}
                  </Draggable>
                );
              })}
              {provided.placeholder}
            </div>

            {tasks.length === 0 && (
              <div className="text-center py-8">
                <p className="text-slate-500 text-sm mb-4">No items yet</p>
              </div>
            )}

            {/* Add Item Button */}
            <button
              onClick={() => setShowCreateTask(true)}
              className="w-full flex items-center justify-center space-x-2 py-3 text-slate-400 hover:text-slate-300 hover:bg-slate-800/50 rounded-md transition-colors"
            >
              <Plus className="w-4 h-4" />
              <span className="text-sm">Add item</span>
            </button>
          </div>
        )}
      </Droppable>

      {/* Column Footer */}
      <div
        className={`p-2 border-2 border-dashed border-t-0 ${colorClasses.border} ${colorClasses.bg} rounded-b-lg`}
      >
        {/* Footer content if needed */}
      </div>

      <CreateTaskForm
        isOpen={showCreateTask}
        onClose={() => setShowCreateTask(false)}
        projectId={projectId}
        initialStatus={status}
      />
    </div>
  );
}
