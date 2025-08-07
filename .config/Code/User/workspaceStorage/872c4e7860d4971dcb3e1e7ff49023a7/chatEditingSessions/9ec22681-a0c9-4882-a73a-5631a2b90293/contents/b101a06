'use client';

import React, { useEffect } from 'react';
import { X, CheckCircle, Clock, Play, Archive } from 'lucide-react';
import { KANBAN_COLUMNS } from '@/utils/dragAndDrop';

interface Task {
  id: string;
  title: string;
  status: 'Todo' | 'In Progress' | 'Done' | 'Next Version';
  priority: 'High' | 'Medium' | 'Low';
  assigneeId?: string;
}

interface MobileStatusPopupProps {
  isOpen: boolean;
  onClose: () => void;
  task: Task | null;
  onStatusChange: (
    taskId: string,
    newStatus: 'Todo' | 'In Progress' | 'Done' | 'Next Version'
  ) => void;
}

const getStatusIcon = (status: string) => {
  switch (status) {
    case 'Todo':
      return <Clock className="w-5 h-5" />;
    case 'In Progress':
      return <Play className="w-5 h-5" />;
    case 'Done':
      return <CheckCircle className="w-5 h-5" />;
    case 'Next Version':
      return <Archive className="w-5 h-5" />;
    default:
      return <Clock className="w-5 h-5" />;
  }
};

const getStatusColor = (status: string) => {
  switch (status) {
    case 'Todo':
      return 'text-slate-400 bg-slate-800 border-slate-600';
    case 'In Progress':
      return 'text-yellow-400 bg-yellow-500/10 border-yellow-500/30';
    case 'Done':
      return 'text-green-400 bg-green-500/10 border-green-500/30';
    case 'Next Version':
      return 'text-purple-400 bg-purple-500/10 border-purple-500/30';
    default:
      return 'text-slate-400 bg-slate-800 border-slate-600';
  }
};

export default function MobileStatusPopup({
  isOpen,
  onClose,
  task,
  onStatusChange,
}: MobileStatusPopupProps) {
  // Close popup on escape key
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      // Prevent body scroll when popup is open
      document.body.style.overflow = 'hidden';
    }

    return () => {
      document.removeEventListener('keydown', handleEscape);
      document.body.style.overflow = 'unset';
    };
  }, [isOpen, onClose]);

  if (!isOpen || !task) return null;

  const handleStatusSelect = (
    newStatus: 'Todo' | 'In Progress' | 'Done' | 'Next Version'
  ) => {
    onStatusChange(task.id, newStatus);
    onClose();
  };

  return (
    <>
      {/* Backdrop */}
      <div
        className={`fixed inset-0 bg-black/50 backdrop-blur-sm z-50 transition-opacity duration-300 ${
          isOpen ? 'opacity-100' : 'opacity-0'
        }`}
        onClick={onClose}
      />

      {/* Popup */}
      <div
        className={`fixed bottom-0 left-0 right-0 bg-slate-900 border-t border-slate-700 rounded-t-2xl z-50 transform transition-transform duration-300 ease-out ${
          isOpen ? 'translate-y-0' : 'translate-y-full'
        }`}
      >
        {/* Handle bar */}
        <div className="flex justify-center pt-3 pb-2">
          <div className="w-10 h-1 bg-slate-600 rounded-full" />
        </div>

        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-700">
          <div>
            <h3 className="text-white font-semibold text-lg">Move Task</h3>
            <p className="text-slate-400 text-sm truncate max-w-[250px]">
              {task.title}
            </p>
          </div>
          <button
            onClick={onClose}
            className="p-2 text-slate-400 hover:text-white transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Current Status */}
        <div className="px-6 py-3 bg-slate-800/50">
          <p className="text-slate-400 text-sm mb-2">Current Status</p>
          <div
            className={`flex items-center space-x-3 px-4 py-3 rounded-lg border ${getStatusColor(
              task.status
            )}`}
          >
            {getStatusIcon(task.status)}
            <span className="font-medium">{task.status}</span>
          </div>
        </div>

        {/* Status Options */}
        <div className="px-6 py-4">
          <p className="text-slate-400 text-sm mb-4">Move to</p>
          <div className="space-y-3 pb-6">
            {KANBAN_COLUMNS.map((column) => {
              const isCurrentStatus = column.status === task.status;
              const colorClasses = getStatusColor(column.status);

              return (
                <button
                  key={column.id}
                  onClick={() => handleStatusSelect(column.status)}
                  disabled={isCurrentStatus}
                  className={`w-full flex items-center justify-between px-4 py-4 rounded-lg border transition-all duration-200 ${
                    isCurrentStatus
                      ? 'opacity-50 cursor-not-allowed bg-slate-800/30 border-slate-700'
                      : `${colorClasses} hover:scale-[1.02] active:scale-[0.98] hover:shadow-lg`
                  }`}
                >
                  <div className="flex items-center space-x-3">
                    {getStatusIcon(column.status)}
                    <div className="text-left">
                      <p className="font-medium">{column.title}</p>
                      <p className="text-xs opacity-70">
                        {column.status === 'Todo' && 'Ready to start'}
                        {column.status === 'In Progress' &&
                          'Currently working on'}
                        {column.status === 'Done' && 'Completed'}
                        {column.status === 'Next Version' && 'Future release'}
                      </p>
                    </div>
                  </div>
                  {isCurrentStatus && (
                    <span className="text-xs text-slate-500">Current</span>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Safe area for mobile devices */}
        <div className="h-6" />
      </div>
    </>
  );
}
