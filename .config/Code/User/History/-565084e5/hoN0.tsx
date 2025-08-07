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
        <button
          onClick={() => router.push('/projects')}
          className="text-blue-500 hover:underline"
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
