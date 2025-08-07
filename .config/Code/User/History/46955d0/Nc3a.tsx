import React, { Component, ReactNode } from 'react';

interface DiscussionErrorFallbackProps {
  error: Error;
  retry: () => void;
}

const DiscussionErrorFallback: React.FC<DiscussionErrorFallbackProps> = ({
  error,
  retry
}) => {
  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center p-4">
      <div className="bg-gray-800 border border-red-600/20 rounded-lg p-6 max-w-md w-full">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-red-600/20 rounded-full flex items-center justify-center">
            <svg className="w-5 h-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
            </svg>
          </div>
          <div>
            <h2 className="text-lg font-semibold text-red-400">Discussion Error</h2>
            <p className="text-sm text-gray-400">Something went wrong loading this discussion</p>
          </div>
        </div>
        
        <div className="bg-gray-900 border border-gray-700 rounded p-3 mb-4">
          <p className="text-sm text-gray-300 font-mono break-words">
            {error.message}
          </p>
        </div>
        
        <div className="flex gap-3">
          <button
            onClick={retry}
            className="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium transition-colors"
          >
            Try Again
          </button>
          <button
            onClick={() => window.history.back()}
            className="px-4 py-2 bg-gray-700 hover:bg-gray-600 text-gray-200 rounded-lg text-sm font-medium transition-colors"
          >
            Go Back
          </button>
        </div>
      </div>
    </div>
  );
};

interface DiscussionErrorBoundaryProps {
  children: ReactNode;
}

interface DiscussionErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

export class DiscussionErrorBoundary extends Component<
  DiscussionErrorBoundaryProps,
  DiscussionErrorBoundaryState
> {
  constructor(props: DiscussionErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): DiscussionErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Discussion Error:', error, errorInfo);
  }

  retry = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError && this.state.error) {
      return <DiscussionErrorFallback error={this.state.error} retry={this.retry} />;
    }

    return this.props.children;
  }
}
