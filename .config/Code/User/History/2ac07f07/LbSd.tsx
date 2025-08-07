'use client';

import React, { useState, useEffect } from 'react';
import { User, PullRequest, Comment, TimelineEvent } from '../../types/discussion';
import { DiscussionTimeline } from './DiscussionTimeline';
import { DiscussionSidebar } from './DiscussionSidebar';
import { CommentEditor } from './CommentEditor';
import { PullRequestHeader } from './PullRequestHeader';
import { MergeStatus } from './MergeStatus';

interface DiscussionPageProps {
  pullRequestId: string;
  initialData?: PullRequest;
}

export const DiscussionPage: React.FC<DiscussionPageProps> = ({
  pullRequestId,
  initialData
}) => {
  const [pullRequest, setPullRequest] = useState<PullRequest | null>(initialData || null);
  const [comments, setComments] = useState<Comment[]>([]);
  const [timelineEvents, setTimelineEvents] = useState<TimelineEvent[]>([]);
  const [loading, setLoading] = useState(!initialData);
  const [error, setError] = useState<string | null>(null);
  const [isSubscribed, setIsSubscribed] = useState(true);
  const [isLocked, setIsLocked] = useState(false);

  useEffect(() => {
    if (!initialData) {
      fetchPullRequestData();
    } else {
      generateTimelineEvents(initialData);
    }
  }, [pullRequestId, initialData]);

  const fetchPullRequestData = async () => {
    try {
      setLoading(true);
      // Simulate API call - replace with actual API endpoint
      const response = await fetch(`/api/pull-requests/${pullRequestId}`);
      if (!response.ok) throw new Error('Failed to fetch pull request');
      
      const data = await response.json();
      setPullRequest(data.pullRequest);
      setComments(data.comments);
      generateTimelineEvents(data.pullRequest, data.comments);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const generateTimelineEvents = (pr: PullRequest, comments: Comment[] = []) => {
    const events: TimelineEvent[] = [];
    
    // Add initial PR creation
    events.push({
      id: `pr-${pr.id}`,
      type: 'comment',
      author: pr.author,
      createdAt: pr.createdAt,
      data: { content: pr.description || 'No description provided.' }
    });

    // Add commits
    pr.commits.forEach(commit => {
      events.push({
        id: `commit-${commit.id}`,
        type: 'commit',
        author: commit.author,
        createdAt: commit.createdAt,
        data: commit
      });
    });

    // Add reviews
    pr.reviews.forEach(review => {
      events.push({
        id: `review-${review.id}`,
        type: 'review',
        author: review.author,
        createdAt: review.createdAt,
        data: review
      });
    });

    // Add comments
    comments.forEach(comment => {
      events.push({
        id: `comment-${comment.id}`,
        type: 'comment',
        author: comment.author,
        createdAt: comment.createdAt,
        data: comment
      });
    });

    // Add merge event if merged
    if (pr.state === 'merged') {
      events.push({
        id: `merge-${pr.id}`,
        type: 'merge',
        author: pr.author, // This should be the merger
        createdAt: pr.updatedAt,
        data: { branch: pr.branch }
      });
    }

    // Sort by date
    events.sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());
    setTimelineEvents(events);
  };

  const handleAddComment = async (content: string) => {
    if (!pullRequest) return;

    try {
      const response = await fetch(`/api/pull-requests/${pullRequestId}/comments`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ content })
      });

      if (!response.ok) throw new Error('Failed to add comment');

      const newComment = await response.json();
      setComments(prev => [...prev, newComment]);
      
      // Add to timeline
      const newEvent: TimelineEvent = {
        id: `comment-${newComment.id}`,
        type: 'comment',
        author: newComment.author,
        createdAt: newComment.createdAt,
        data: newComment
      };
      setTimelineEvents(prev => [...prev, newEvent]);
    } catch (err) {
      console.error('Failed to add comment:', err);
    }
  };

  const handleSubscriptionToggle = () => {
    setIsSubscribed(!isSubscribed);
  };

  const handleLockToggle = () => {
    setIsLocked(!isLocked);
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-96 gap-4">
        <div className="w-8 h-8 border-3 border-gray-700 border-t-blue-500 rounded-full animate-spin" />
        <p>Loading discussion...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-96 gap-4 text-center">
        <h2 className="text-xl font-semibold text-red-400">Error loading discussion</h2>
        <p>{error}</p>
        <button onClick={fetchPullRequestData} className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-md font-medium transition-colors">
          Try Again
        </button>
      </div>
    );
  }

  if (!pullRequest) {
    return (
      <div className="flex flex-col items-center justify-center min-h-96 gap-4 text-center">
        <h2 className="text-xl font-semibold">Pull request not found</h2>
        <p>The requested pull request could not be found.</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-900 text-gray-100">
      <div className="max-w-7xl mx-auto px-6 py-6">
        <PullRequestHeader pullRequest={pullRequest} />
        
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 mt-6">
          <main className="lg:col-span-3 min-w-0">
            <DiscussionTimeline 
              events={timelineEvents}
              pullRequest={pullRequest}
            />
            
            {pullRequest.state === 'merged' && (
              <MergeStatus 
                pullRequest={pullRequest}
                onDeleteBranch={() => {}}
              />
            )}

            {!isLocked && (
              <div className="mt-6 pt-6 border-t border-gray-700">
                <CommentEditor
                  onSubmit={handleAddComment}
                  placeholder="Add your comment here..."
                  currentUser={{
                    id: 'current-user',
                    username: 'nyambogahezron',
                    avatar: '/avatars/current-user.jpg'
                  }}
                />
              </div>
            )}

            {isLocked && (
              <div className="flex flex-col items-center justify-center py-8 mt-6 bg-gray-800 border border-gray-700 rounded-lg text-center">
                <div className="text-2xl mb-2">🔒</div>
                <p className="text-gray-400">This conversation has been locked and limited to collaborators.</p>
              </div>
            )}
          </main>

          <aside className="lg:col-span-1 lg:sticky lg:top-6 h-fit">
            <DiscussionSidebar
              pullRequest={pullRequest}
              isSubscribed={isSubscribed}
              onSubscriptionToggle={handleSubscriptionToggle}
              onLockToggle={handleLockToggle}
              isLocked={isLocked}
            />
          </aside>
        </div>
      </div>
    </div>
  );
};