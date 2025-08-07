import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import ProjectsListing from '../components/ProjectsListing';
import ProjectDetail from '../components/ProjectDetail';
import DiscussionPageRoute from '../app/discussion/[id]/page';

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
  {
    path: '/discussion/:id',
    element: <DiscussionPageRoute />,
  },
]);

export function AppRouter() {
  return <RouterProvider router={router} />;
}

export default router;
