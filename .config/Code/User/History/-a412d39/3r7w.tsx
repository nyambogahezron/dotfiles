'use client';

import { createContext, useContext, ReactNode } from 'react';
import { useProjectId } from '@/hooks/useProjectId';
import { useProjectStore } from '@/store/useProjectStore';

interface ProjectContextType {
  projectId: string | null;
  isValidProject: boolean;
  currentProject: any;
}

const ProjectContext = createContext<ProjectContextType | undefined>(undefined);

export function ProjectProvider({ children }: { children: ReactNode }) {
  const { projectId, isValidProject } = useProjectId();
  const { getCurrentProject } = useProjectStore();
  const currentProject = getCurrentProject();

  return (
    <ProjectContext.Provider
      value={{
        projectId,
        isValidProject,
        currentProject,
      }}
    >
      {children}
    </ProjectContext.Provider>
  );
}

export function useProjectContext() {
  const context = useContext(ProjectContext);
  if (context === undefined) {
    throw new Error('useProjectContext must be used within a ProjectProvider');
  }
  return context;
}
