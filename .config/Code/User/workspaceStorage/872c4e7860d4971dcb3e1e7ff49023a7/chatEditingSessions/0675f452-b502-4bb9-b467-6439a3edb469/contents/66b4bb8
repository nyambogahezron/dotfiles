'use client';

import React from 'react';
import { useProjectId } from '@/hooks/useProjectId';
import { useProjectStore } from '@/store/useProjectStore';

export default function Chats() {
	const { projectId, isValidProject } = useProjectId();
	const { getCurrentProject } = useProjectStore();
	
	const currentProject = getCurrentProject();
	
	if (!isValidProject) {
		return <div>Invalid project</div>;
	}
	
	return (
		<div className="p-6">
			<h1 className="text-2xl font-bold text-white mb-4">
				Chats - {currentProject?.name || `Project ${projectId}`}
			</h1>
			<div className="text-slate-300">
				<p>Current Project ID: {projectId}</p>
				<p>Project Name: {currentProject?.name || 'Not found in store'}</p>
				{/* Add your chat functionality here */}
			</div>
		</div>
	);
}
