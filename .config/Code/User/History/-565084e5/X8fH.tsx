'use client';

import ProjectHeader from '@/components/project/ProjectHeader';
import { useRouter } from 'next/navigation';
import React from 'react';
import { useProjectId } from '@/hooks/useProjectId';
import { ProjectProvider } from '@/contexts/ProjectContext';

export default function ProjectsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const [activeTab, setActiveTab] = React.useState('backlog');
  const { isValidProject } = useProjectId();
  const router = useRouter();

  const onTabChange = (tab: string) => {
    setActiveTab(tab);
  };

  if (!isValidProject) {
    return (
      <div className="border-b border-slate-700 bg-slate-900 px-6 py-4">
        <h1 className="text-2xl font-semibold text-white">Project Not Found</h1>
        <p className="text-slate-400 mt-2">
          The requested project could not be found.
        </p>
        <button
          onClick={() => router.push('/projects')}
          className="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors"
        >
          Go to Projects
        </button>
      </div>
    );
  }

  return (
    <ProjectProvider>
      <div className="bg-slate-900">
        <ProjectHeader activeTab={activeTab} onTabChange={onTabChange} />
        {children}
      </div>
    </ProjectProvider>
  );
}
