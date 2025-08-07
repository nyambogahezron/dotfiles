/**
 * Utility functions for managing notifications in the project header
 */

export interface NotificationCounts {
  chats: number;
  general: number;
}

// Mock notification counts - replace with actual data from your store/API
export const useNotificationCounts = (): NotificationCounts => {
  // This is a simple mock - you can replace this with actual logic
  // that fetches notification counts from your store or API
  return {
    chats: 2, // Number of unread chat messages
    general: 5, // Number of general notifications
  };
};

// Helper function to format notification count for display
export const formatNotificationCount = (count: number): string => {
  if (count === 0) return '';
  if (count > 99) return '99+';
  return count.toString();
};
