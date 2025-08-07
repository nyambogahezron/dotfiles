'use client';

import TeamCapacityView from '@/components/project/views/TeamCapacityView';
import React from 'react';
import { useProjectContext } from '@/contexts/ProjectContext';

export default function TeamCapacity() {
  // Project context is available here for any project-specific logic
  const { projectId, currentProject } = useProjectContext();

  // You can now use projectId and currentProject in your component logic
  console.log(
    'Team Capacity - Current Project:',
    projectId,
    currentProject?.name
  );

  return (
    <>
      <TeamCapacityView />
    </>
  );
}
