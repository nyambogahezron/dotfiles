'use client';

import React, { useState } from 'react';
import { User } from '../../types/discussion';

interface CommentEditorProps {
  onSubmit: (content: string) => void;
  placeholder?: string;
  currentUser: User;
  initialContent?: string;
}

export const CommentEditor: React.FC<CommentEditorProps> = ({
  onSubmit,
  placeholder = "Add your comment here...",
  currentUser,
  initialContent = ""
}) => {
  const [content, setContent] = useState(initialContent);
  const [activeTab, setActiveTab] = useState<'write' | 'preview'>('write');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!content.trim() || isSubmitting) return;

    setIsSubmitting(true);
    try {
      await onSubmit(content);
      setContent('');
      setActiveTab('write');
    } catch (error) {
      console.error('Failed to submit comment:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) {
      handleSubmit(e);
    }
  };

  return (
    <div className="bg-gray-900 border border-gray-600 rounded-lg overflow-hidden">
      <div className="flex items-center gap-3 px-4 py-2 bg-gray-800 border-b border-gray-600">
        <img 
          src={currentUser.avatar} 
          alt={currentUser.username}
          className="w-8 h-8 rounded-full flex-shrink-0"
        />
        <div className="flex gap-4">
          <button
            className={`py-2 text-sm border-b-2 transition-colors ${
              activeTab === 'write' 
                ? 'text-gray-100 border-orange-500' 
                : 'text-gray-400 border-transparent hover:text-gray-100'
            }`}
            onClick={() => setActiveTab('write')}
          >
            Write
          </button>
          <button
            className={`py-2 text-sm border-b-2 transition-colors ${
              activeTab === 'preview' 
                ? 'text-gray-100 border-orange-500' 
                : 'text-gray-400 border-transparent hover:text-gray-100'
            }`}
            onClick={() => setActiveTab('preview')}
          >
            Preview
          </button>
        </div>
        <div className="flex items-center gap-2 ml-auto">
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add header text">
            <strong>H</strong>
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add bold text">
            <strong>B</strong>
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add italic text">
            <em>I</em>
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Insert code">
            <code>&lt;&gt;</code>
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add a link">
            🔗
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add a bulleted list">
            •
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add a numbered list">
            1.
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add a task list">
            ☑
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Directly mention a user or team">
            @
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Reference an issue or pull request">
            #
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Add saved reply">
            💾
          </button>
          <button className="flex items-center justify-center w-6 h-6 text-gray-400 hover:text-gray-100 hover:bg-gray-600 rounded text-xs transition-colors" title="Attach files">
            📎
          </button>
        </div>
      </div>

      <div className="relative">
        {activeTab === 'write' ? (
          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder={placeholder}
            className="w-full min-h-32 p-4 bg-gray-900 border-none text-gray-100 text-sm font-sans leading-relaxed resize-y outline-none placeholder-gray-400 disabled:opacity-60 disabled:cursor-not-allowed"
            rows={6}
            disabled={isSubmitting}
          />
        ) : (
          <div className="min-h-32 p-4 text-gray-100 leading-relaxed">
            {content ? (
              <div dangerouslySetInnerHTML={{ __html: content }} />
            ) : (
              <p className="text-gray-400 italic">Nothing to preview</p>
            )}
          </div>
        )}
      </div>

      <div className="flex items-center justify-between px-4 py-2 bg-gray-800 border-t border-gray-600">
        <div className="flex items-center gap-2">
          <span className="text-xs text-gray-400">
            Styling with Markdown is supported
          </span>
        </div>
        <button
          type="submit"
          onClick={handleSubmit}
          disabled={!content.trim() || isSubmitting}
          className="px-4 py-2 bg-green-600 hover:bg-green-700 disabled:bg-gray-700 disabled:text-gray-400 disabled:cursor-not-allowed text-white rounded-lg text-sm font-medium transition-colors"
        >
          {isSubmitting ? 'Commenting...' : 'Comment'}
        </button>
      </div>
    </div>
  );
};