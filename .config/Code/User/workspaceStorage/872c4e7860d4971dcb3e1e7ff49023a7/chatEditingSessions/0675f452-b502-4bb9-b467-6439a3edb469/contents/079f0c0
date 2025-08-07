'use client';

import React from 'react';
import { useProjectContext } from '@/contexts/ProjectContext';

export default function ActivitiesPage() {
  const { projectId, currentProject } = useProjectContext();

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold text-white mb-4">
        Activities - {currentProject?.name || `Project ${projectId}`}
      </h1>
      <div className="text-slate-300">
        <p>Current Project ID: {projectId}</p>
        <p>Project Name: {currentProject?.name || 'Not found in store'}</p>
        {/* Add your activities functionality here */}
      </div>
    </div>
  );
}
