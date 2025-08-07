import React from 'react';
import { useRouter } from 'next/navigation';
import { Lock, Plus, MessageCircle, Bell, Menu, X, ChevronDown } from 'lucide-react';
import Link from 'next/link';
import NewViewModal from './views/NewViewModal';
import { useProjectId } from '@/hooks/useProjectId';
import useProjectStore from '@/store/useProjectStore';
import {
  useNotificationCounts,
  formatNotificationCount,
} from '@/utils/notifications';

interface ProjectHeaderProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}
const tabKeys = [
  'backlog',
  'team-capacity',
  'current-iteration',
  'timeline',
  'my-items',
  'chats',
  'resources',
  'activities',
] as const;

type TabKey = (typeof tabKeys)[number];

const links: Record<TabKey, string> = {
  backlog: '/project/[projectId]/',
  'team-capacity': '/project/[projectId]/team-capacity',
  'current-iteration': '/project/[projectId]/current-iteration',
  timeline: '/project/[projectId]/timeline',
  'my-items': '/project/[projectId]/my-items',
  chats: '/project/[projectId]/chats',
  resources: '/project/[projectId]/resources',
  activities: '/project/[projectId]/activities',
};

export default function ProjectHeader({
  activeTab,
  onTabChange,
}: ProjectHeaderProps) {
  const router = useRouter();
  const { projectId } = useProjectId();
  const getCurrentProject = useProjectStore((state) => state.getCurrentProject);
  const [showNewViewModal, setShowNewViewModal] = React.useState(false);
  const [mobileTabsOpen, setMobileTabsOpen] = React.useState(false);
  const notificationCounts = useNotificationCounts();

  const handleCreateView = (viewName: string, viewType: string) => {
    console.log(`Creating view: ${viewName} of type ${viewType}`);
    setShowNewViewModal(false);
    onTabChange(`custom-${viewName.toLowerCase().replace(/\s+/g, '-')}`);
  };

  // Get current project from store
  const currentProject = getCurrentProject();

  // If no current project found, redirect to projects page
  React.useEffect(() => {
    if (!currentProject) {
      router.push('/projects');
    }
  }, [currentProject, router]);

  // If no project, don't render anything (will redirect)
  if (!currentProject) {
    return null;
  }

  const projectName = currentProject.name;
  
  // Helper function to get active tab display name
  const getActiveTabName = () => {
    const activeTabKey = tabKeys.find(tab => tab === activeTab);
    if (activeTabKey) {
      return activeTabKey.charAt(0).toUpperCase() + activeTabKey.slice(1).replace(/-/g, ' ');
    }
    return 'Backlog';
  };

  return (
    <div className="border-b border-slate-700 bg-slate-900">
      <NewViewModal
        isOpen={showNewViewModal}
        onClose={() => setShowNewViewModal(false)}
        onCreateView={handleCreateView}
      />
      
      {/* Mobile Header */}
      <div className="block lg:hidden">
        <div className="px-4 py-3">
          {/* Top row: Back button, Project name, Actions */}
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center space-x-3">
              <button
                onClick={() => router.push('/projects')}
                className="text-slate-400 hover:text-white transition-colors"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
                </svg>
              </button>
              <div>
                <div className="text-white font-medium text-sm truncate max-w-[180px]">
                  {projectName}
                </div>
                <div className="text-slate-400 text-xs">
                  {getActiveTabName()}
                </div>
              </div>
            </div>
            
            <div className="flex items-center space-x-2">
              {/* Notification Icons */}
              <button
                className="relative p-2 text-slate-400 hover:text-white transition-colors"
                onClick={() => router.push(`/project/${projectId}/chats`)}
              >
                <MessageCircle className="w-5 h-5" />
                {notificationCounts.chats > 0 && (
                  <span className="absolute -top-1 -right-1 min-w-[1.25rem] h-5 bg-blue-500 rounded-full text-xs text-white flex items-center justify-center px-1">
                    {formatNotificationCount(notificationCounts.chats)}
                  </span>
                )}
              </button>
              <button
                className="relative p-2 text-slate-400 hover:text-white transition-colors"
                onClick={() => router.push(`/project/${projectId}/activities`)}
              >
                <Bell className="w-5 h-5" />
                {notificationCounts.general > 0 && (
                  <span className="absolute -top-1 -right-1 min-w-[1.25rem] h-5 bg-red-500 rounded-full text-xs text-white flex items-center justify-center px-1">
                    {formatNotificationCount(notificationCounts.general)}
                  </span>
                )}
              </button>
              <button
                onClick={() => setMobileTabsOpen(!mobileTabsOpen)}
                className="p-2 text-slate-400 hover:text-white transition-colors"
              >
                {mobileTabsOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
              </button>
            </div>
          </div>
          
          {/* Tab selector dropdown */}
          <div className="relative">
            <button
              onClick={() => setMobileTabsOpen(!mobileTabsOpen)}
              className="w-full flex items-center justify-between px-4 py-2 bg-slate-800 rounded-lg text-white text-sm"
            >
              <span>{getActiveTabName()}</span>
              <ChevronDown className={`w-4 h-4 transition-transform ${mobileTabsOpen ? 'rotate-180' : ''}`} />
            </button>
            
            {mobileTabsOpen && (
              <div className="absolute top-full left-0 right-0 mt-1 bg-slate-800 rounded-lg border border-slate-700 shadow-lg z-50">
                {tabKeys.map((tab) => (
                  <Link
                    key={tab}
                    href={links[tab].replace('[projectId]', projectId || 'default')}
                    onClick={() => {
                      onTabChange(tab);
                      setMobileTabsOpen(false);
                    }}
                    className={`block px-4 py-3 text-sm border-b border-slate-700 last:border-b-0 transition-colors ${
                      activeTab === tab
                        ? 'text-white bg-slate-700'
                        : 'text-slate-400 hover:text-white hover:bg-slate-750'
                    }`}
                  >
                    {tab.charAt(0).toUpperCase() + tab.slice(1).replace(/-/g, ' ')}
                  </Link>
                ))}
                <button
                  onClick={() => {
                    setShowNewViewModal(true);
                    setMobileTabsOpen(false);
                  }}
                  className="w-full flex items-center px-4 py-3 text-sm text-slate-400 hover:text-white hover:bg-slate-750 transition-colors"
                >
                  <Plus className="w-4 h-4 mr-2" />
                  New View
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Desktop Header */}
      <div className="hidden lg:block">
        <div className="px-6 py-4">
          {/* Notification Icons and Breadcrumb */}
          <div className="flex items-center justify-between mb-4">
            {/* Left side: Notification Icons */}
            <div className="flex items-center space-x-3">
              <button
                className="relative p-2 text-slate-400 hover:text-white transition-colors"
                onClick={() => router.push(`/project/${projectId}/chats`)}
                title="Chat notifications"
              >
                <MessageCircle className="w-5 h-5" />
                {/* Chat notification badge */}
                {notificationCounts.chats > 0 && (
                  <span className="absolute -top-1 -right-1 min-w-[1.25rem] h-5 bg-blue-500 rounded-full text-xs text-white flex items-center justify-center px-1">
                    {formatNotificationCount(notificationCounts.chats)}
                  </span>
                )}
              </button>
              <button
                className="relative p-2 text-slate-400 hover:text-white transition-colors"
                onClick={() => router.push(`/project/${projectId}/activities`)}
                title="General notifications"
              >
                <Bell className="w-5 h-5" />
                {/* General notification badge */}
                {notificationCounts.general > 0 && (
                  <span className="absolute -top-1 -right-1 min-w-[1.25rem] h-5 bg-red-500 rounded-full text-xs text-white flex items-center justify-center px-1">
                    {formatNotificationCount(notificationCounts.general)}
                  </span>
                )}
              </button>
            </div>

            {/* Right side: Breadcrumb */}
            <div className="flex items-center text-sm text-slate-400">
              <button
                onClick={() => router.push('/projects')}
                className="hover:text-slate-300 cursor-pointer"
              >
                Projects
              </button>
              <span className="mx-2">/</span>
              <span className="text-white font-medium">{projectName}</span>
              <Lock className="w-4 h-4 ml-2 text-slate-400" />
            </div>
          </div>

          {/* Project Title and Actions */}
          <div className="flex items-center gap-4 mb-6">
            <div className="flex items-center space-x-3">
              <div className="flex items-center space-x-6">
                {tabKeys.map((tab) => (
                  <Link
                    key={tab}
                    href={links[tab].replace(
                      '[projectId]',
                      projectId || 'default'
                    )}
                    onClick={() => onTabChange(tab)}
                    className={`text-sm font-medium ${
                      activeTab === tab
                        ? 'text-white border-b-2 border-blue-500'
                        : 'text-slate-400 hover:text-white'
                    } transition-colors`}
                  >
                    {tab.charAt(0).toUpperCase() +
                      tab.slice(1).replace(/-/g, ' ')}
                  </Link>
                ))}
                <button
                  onClick={() => {
                    setShowNewViewModal(true);
                  }}
                  className="flex items-center text-sm text-slate-400 hover:text-white transition-colors"
                >
                  <Plus className="w-4 h-4 mr-1" />
                  New View
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
