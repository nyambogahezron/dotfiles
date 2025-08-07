'use client';

import KanbanBoard from '@/components/Kanban/KanbanBoard';
import { useProjectId } from '@/hooks/useProjectId';

export default function Kanban() {
	const { projectId, isValidProject } = useProjectId();

	console.log('Project ID:', projectId);

	if (!isValidProject) {
		return <div>Invalid project</div>;
	}

	return (
		<>
			<KanbanBoard projectId={projectId || ''} />
		</>
	);
}
