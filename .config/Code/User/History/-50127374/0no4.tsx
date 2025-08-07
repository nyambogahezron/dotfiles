import { RouteObject } from 'react-router-dom';
import DiscussionPageRoute from '../app/discussion/[id]/page';
import { DiscussionErrorBoundary } from '../components/discussion/DiscussionErrorBoundary';

// Discussion-specific routes
export const discussionRoutes: RouteObject[] = [
	{
		path: '/discussion/:id',
		element: (
			<DiscussionErrorBoundary>
				<DiscussionPageRoute />
			</DiscussionErrorBoundary>
		),
		errorElement: (
			<div className='p-4 text-red-400'>Error loading discussion</div>
		),
	},
	// You can add more discussion-related routes here
	// For example:
	// {
	//   path: '/discussions',
	//   element: <DiscussionsList />,
	// },
	// {
	//   path: '/discussion/:id/files',
	//   element: <DiscussionFiles />,
	// },
	// {
	//   path: '/discussion/:id/commits',
	//   element: <DiscussionCommits />,
	// },
];

export default discussionRoutes;
