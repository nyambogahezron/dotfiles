import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import ProjectsListing from './components/ProjectsListing';
import ProjectDetail from './components/ProjectDetail';
import DiscussionPageRoute from './app/discussion/[id]/page';

function App() {
	return (
		<Router>
			<Routes>
				{/* Home route */}
				<Route path='/' element={<ProjectsListing />} />
				
				{/* Project routes */}
				<Route path='/projects' element={<ProjectsListing />} />
				<Route path='/project/:projectId' element={<ProjectDetail />} />
				
				{/* Discussion routes */}
				<Route path='/discussion/:id' element={<DiscussionPageRoute />} />
			</Routes>
		</Router>
	);
}

export default App;
