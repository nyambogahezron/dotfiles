import React, { createContext, useContext, useEffect, useState } from 'react';

export interface DownloadItem {
  id: string;
  mediaId: string;
  mediaType: 'movie' | 'tv';
  title: string;
  poster?: string;
  quality: string;
  fileSize: string;
  estimatedTime: string;
  status: 'pending' | 'downloading' | 'paused' | 'completed' | 'failed';
  progress: number;
  downloadSpeed?: string;
  eta?: string;
  createdAt: string;
  updatedAt: string;
}

interface DownloadContextType {
  downloads: DownloadItem[];
  addDownload: (
    item: Omit<DownloadItem, 'id' | 'status' | 'progress' | 'createdAt' | 'updatedAt'>,
  ) => void;
  removeDownload: (id: string) => void;
  pauseDownload: (id: string) => void;
  resumeDownload: (id: string) => void;
  updateDownloadProgress: (id: string, progress: number, speed?: string, eta?: string) => void;
  updateDownloadStatus: (id: string, status: DownloadItem['status']) => void;
  getDownloadById: (id: string) => DownloadItem | undefined;
  isDownloading: (mediaId: string) => boolean;
  refreshDownloads: () => Promise<void>;
}

const DownloadContext = createContext<DownloadContextType | undefined>(undefined);

interface DownloadProviderProps {
  children: React.ReactNode;
}

export function DownloadProvider({ children }: DownloadProviderProps) {
  const [downloads, setDownloads] = useState<DownloadItem[]>([]);

  // Load downloads from storage on mount
  useEffect(() => {
    loadDownloads();
  }, []);

  // Save downloads to storage whenever downloads change
  useEffect(() => {
    saveDownloads();
  }, [downloads]);

  const loadDownloads = async () => {
    try {
      const getDownloads = () => {};
    } catch (error) {
      console.error('Error loading downloads:', error);
    }
  };

  const saveDownloads = async () => {
    try {
      const SaveDownloads = () => {};
    } catch (error) {
      console.error('Error saving downloads:', error);
    }
  };

  const addDownload = (
    item: Omit<DownloadItem, 'id' | 'status' | 'progress' | 'createdAt' | 'updatedAt'>,
  ) => {
    // Check if already downloading
    const existingDownload = downloads.find(
      (d) => d.mediaId === item.mediaId && d.mediaType === item.mediaType,
    );

    const newDownload: DownloadItem = {
      ...item,
      id: `${item.mediaId}-${item.mediaType}-${Date.now()}`,
      status: 'pending',
      progress: 0,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    setDownloads((prev) => [newDownload, ...prev]);

    // Auto-start download
    setTimeout(() => startDownload(newDownload), 1000);
  };

  const removeDownload = (id: string) => {
    setDownloads((prev) => prev.filter((download) => download.id !== id));
  };

  const pauseDownload = (id: string) => {
    setDownloads((prev) =>
      prev.map((download) =>
        download.id === id
          ? {
              ...download,
              status: 'paused' as const,
              updatedAt: new Date().toISOString(),
            }
          : download,
      ),
    );
  };

  const resumeDownload = (id: string) => {
    setDownloads((prev) =>
      prev.map((download) =>
        download.id === id
          ? {
              ...download,
              status: 'downloading' as const,
              updatedAt: new Date().toISOString(),
            }
          : download,
      ),
    );

    const download = downloads.find((d) => d.id === id);
    if (download) {
      startDownload(download);
    }
  };

  const updateDownloadProgress = (id: string, progress: number, speed?: string, eta?: string) => {
    setDownloads((prev) =>
      prev.map((download) =>
        download.id === id
          ? {
              ...download,
              progress,
              downloadSpeed: speed,
              eta,
              updatedAt: new Date().toISOString(),
            }
          : download,
      ),
    );
  };

  const updateDownloadStatus = (id: string, status: DownloadItem['status']) => {
    setDownloads((prev) =>
      prev.map((download) =>
        download.id === id
          ? { ...download, status, updatedAt: new Date().toISOString() }
          : download,
      ),
    );
  };

  const getDownloadById = (id: string) => {
    return downloads.find((download) => download.id === id);
  };

  const isDownloading = (mediaId: string) => {
    return downloads.some(
      (download) =>
        download.mediaId === mediaId &&
        (download.status === 'downloading' || download.status === 'pending'),
    );
  };

  const refreshDownloads = async () => {
    await loadDownloads();
  };

  const startDownload = async (download: DownloadItem) => {
    updateDownloadStatus(download.id, 'downloading');

    const simulateProgress = async () => {
      let progress = download.progress;

      while (progress < 100) {
        // Check if download was paused or removed
        const currentDownload = downloads.find((d) => d.id === download.id);
        if (!currentDownload || currentDownload.status === 'paused') {
          break;
        }

        progress += Math.random() * 10;
        if (progress > 100) progress = 100;

        const speedMBps = (Math.random() * 5 + 1).toFixed(1);
        const remainingMB = ((100 - progress) / 100) * 1000; // Assume 1GB file
        const etaMinutes = Math.ceil(remainingMB / parseFloat(speedMBps) / 60);

        updateDownloadProgress(
          download.id,
          Math.round(progress),
          `${speedMBps} MB/s`,
          `${etaMinutes}m`,
        );

        await new Promise((resolve) => setTimeout(resolve, 1000));
      }

      if (progress >= 100) {
        updateDownloadStatus(download.id, 'completed');
      }
    };

    simulateProgress();
  };

  const contextValue: DownloadContextType = {
    downloads,
    addDownload,
    removeDownload,
    pauseDownload,
    resumeDownload,
    updateDownloadProgress,
    updateDownloadStatus,
    getDownloadById,
    isDownloading,
    refreshDownloads,
  };

  return <DownloadContext.Provider value={contextValue}>{children}</DownloadContext.Provider>;
}

export function useDownloads() {
  const context = useContext(DownloadContext);
  if (context === undefined) {
    throw new Error('useDownloads must be used within a DownloadProvider');
  }
  return context;
}
