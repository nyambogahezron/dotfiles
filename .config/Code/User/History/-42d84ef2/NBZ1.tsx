import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import ProjectsListing from '../components/ProjectsListing';
import ProjectDetail from '../components/ProjectDetail';
import { discussionRoutes } from './discussionRoutes';

const router = createBrowserRouter([
	{
		path: '/',
		element: <ProjectsListing />,
	},
	{
		path: '/projects',
		element: <ProjectsListing />,
	},
	{
		path: '/project/:projectId',
		element: <ProjectDetail />,
	},
	// Spread discussion routes
	...discussionRoutes,
]);

export function AppRouter() {
	return <RouterProvider router={router} />;
}
