import React from 'react';
import { useRouter } from 'next/navigation';
import { Lock, Plus, MessageCircle, Bell } from 'lucide-react';
import Link from 'next/link';
import NewViewModal from './views/NewViewModal';
import { useProjectId } from '@/hooks/useProjectId';
import useProjectStore from '@/store/useProjectStore';
import { useNotificationCounts, formatNotificationCount } from '@/utils/notifications';

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

  const projectName = currentProject.name;  return (
    <div className="border-b border-slate-700 bg-slate-900">
      <NewViewModal
        isOpen={showNewViewModal}
        onClose={() => setShowNewViewModal(false)}
        onCreateView={handleCreateView}
      />
      <div className="px-6 py-4">
        {/* Notification Icons and Breadcrumb */}
        <div className="flex items-center justify-between mb-4">
          {/* Left side: Notification Icons */}
          <div className="flex items-center space-x-3">
            <button className="relative p-2 text-slate-400 hover:text-white transition-colors">
              <MessageCircle className="w-5 h-5" />
              {/* Chat notification badge */}
              <span className="absolute -top-1 -right-1 w-3 h-3 bg-blue-500 rounded-full text-xs flex items-center justify-center">
                <span className="w-1.5 h-1.5 bg-white rounded-full"></span>
              </span>
            </button>
            <button className="relative p-2 text-slate-400 hover:text-white transition-colors">
              <Bell className="w-5 h-5" />
              {/* General notification badge */}
              <span className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full text-xs flex items-center justify-center">
                <span className="w-1.5 h-1.5 bg-white rounded-full"></span>
              </span>
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
  );
}
