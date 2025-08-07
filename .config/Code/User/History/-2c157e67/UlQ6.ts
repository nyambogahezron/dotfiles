import { useNavigate, useLocation, useParams } from 'react-router-dom';
import {
	navigateToDiscussion,
	navigateToDiscussionFiles,
	navigateToDiscussionCommits,
	isDiscussionRoute,
	extractDiscussionId,
} from './discussionUtils';

/**
 * Custom hook for discussion navigation
 */
export const useDiscussionNavigation = () => {
	const navigate = useNavigate();
	const location = useLocation();
	const params = useParams();

	const currentDiscussionId =
		params.id || extractDiscussionId(location.pathname);
	const isOnDiscussionRoute = isDiscussionRoute(location.pathname);

	const goToDiscussion = (id: string) => {
		navigate(navigateToDiscussion(id));
	};

	const goToDiscussionFiles = (id?: string) => {
		const discussionId = id || currentDiscussionId;
		if (discussionId) {
			navigate(navigateToDiscussionFiles(discussionId));
		}
	};

	const goToDiscussionCommits = (id?: string) => {
		const discussionId = id || currentDiscussionId;
		if (discussionId) {
			navigate(navigateToDiscussionCommits(discussionId));
		}
	};

	const goBack = () => {
		navigate(-1);
	};

	const goToDiscussions = () => {
		navigate('/discussions');
	};

	return {
		// Navigation functions
		goToDiscussion,
		goToDiscussionFiles,
		goToDiscussionCommits,
		goBack,
		goToDiscussions,

		// Current state
		currentDiscussionId,
		isOnDiscussionRoute,
		pathname: location.pathname,
	};
};
