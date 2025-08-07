'use client';

import React from 'react';
import { PullRequest } from '../../types/discussion';

interface PullRequestHeaderProps {
  pullRequest: PullRequest;
}

export const PullRequestHeader: React.FC<PullRequestHeaderProps> = ({
  pullRequest
}) => {
  const getStatusIcon = () => {
    switch (pullRequest.state) {
      case 'merged':
        return (
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" className="text-purple-100">
            <path d="M5.45 5.154A4.25 4.25 0 009.25 7.5h1.378a2.251 2.251 0 110 1.5H9.25A5.734 5.734 0 018 8.653v3.097a2.25 2.25 0 11-1.5 0V8.653a5.734 5.734 0 01-1.25.347v2.25a2.25 2.25 0 11-1.5 0V6.5a2.25 2.25 0 111.5 0v1.25A4.25 4.25 0 005.45 5.154z"/>
          </svg>
        );
      case 'closed':
        return (
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" className="text-red-100">
            <path d="M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z"/>
          </svg>
        );
      default:
        return (
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" className="text-green-100">
            <path d="M7.177 3.073L9.573.677A.25.25 0 0110 .854v4.792a.25.25 0 01-.427.177L7.177 3.427a.25.25 0 010-.354zM3.75 2.5a.75.75 0 100 1.5.75.75 0 000-1.5zm-2.25.75a2.25 2.25 0 113 2.122v5.256a2.251 2.251 0 11-1.5 0V5.372A2.25 2.25 0 011.5 3.25zM11 2.5h-1V4h1a1 1 0 011 1v5.628a2.251 2.251 0 101.5 0V5A2.5 2.5 0 0011 2.5zm1 10.25a.75.75 0 111.5 0 .75.75 0 01-1.5 0zM3.75 12a.75.75 0 100 1.5.75.75 0 000-1.5z"/>
          </svg>
        );
    }
  };

  const getStatusText = () => {
    switch (pullRequest.state) {
      case 'merged':
        return 'Merged';
      case 'closed':
        return 'Closed';
      default:
        return 'Open';
    }
  };

  return (
    <div className="border-b border-gray-700 pb-4">
      <div className="flex flex-col gap-2">
        <h1 className="flex items-center gap-2 text-2xl lg:text-3xl font-normal text-gray-100 leading-tight">
          {pullRequest.title}
          <span className="text-gray-400 font-light">#{pullRequest.number}</span>
        </h1>
        
        <div className="flex items-center gap-2 flex-wrap">
          <div className={`flex items-center gap-1 px-2 py-1 rounded-full text-sm font-medium ${
            pullRequest.state === 'merged' ? 'bg-purple-600 text-white' :
            pullRequest.state === 'closed' ? 'bg-red-600 text-white' :
            'bg-green-600 text-white'
          }`}>
            {getStatusIcon()}
            <span>{getStatusText()}</span>
          </div>
          
          <div className="text-sm text-gray-400">
            <span>
              <strong className="text-gray-100">{pullRequest.author.username}</strong> wants to merge commits into{' '}
              <code className="font-mono text-xs text-blue-400 bg-gray-800 px-1.5 py-0.5 rounded border border-gray-600">{pullRequest.branch.target}</code> from{' '}
              <code className="font-mono text-xs text-blue-400 bg-gray-800 px-1.5 py-0.5 rounded border border-gray-600">{pullRequest.branch.source}</code>
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};