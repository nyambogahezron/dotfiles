import React, { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useWebAuth } from '../../context/AuthContext';

interface ProtectedRouteProps {
	children: React.ReactNode;
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children }) => {
	const { isAuthenticated, isLoading } = useWebAuth();
	const navigate = useNavigate();

	useEffect(() => {
		if (!isLoading && !isAuthenticated) {
			navigate('/auth/login');
		}
	}, [isAuthenticated, isLoading, navigate]);

	if (isLoading) {
		return (
			<div className="min-h-screen flex items-center justify-center bg-gray-950">
				<div className="text-center">
					<div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
					<p className="text-gray-400">Loading...</p>
				</div>
			</div>
		);
	}

	if (!isAuthenticated) {
		return null; // Will redirect via useEffect
	}

	return <>{children}</>;
};

export default ProtectedRoute;
