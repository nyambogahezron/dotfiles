'use client';

import { useParams } from 'next/navigation';
import { useEffect } from 'react';
import useProjectStore from '@/store/useProjectStore';

/**
 * Custom hook to track and synchronize project ID from URL params with the global store
 * This ensures that the current project is properly tracked across all routes
 */
export function useProjectId() {
  const params = useParams();
  const { setCurrentProject, currentProjectId } = useProjectStore();

  // Extract projectId from URL params
  const projectId =
    typeof params?.projectId === 'string' ? params.projectId : null;

  // Sync URL project ID with store
  useEffect(() => {
    if (projectId && projectId !== currentProjectId) {
      setCurrentProject(projectId);
    }
  }, [projectId, currentProjectId, setCurrentProject]);

  return {
    projectId,
    isValidProject: !!projectId,
  };
}
