// Platform detection utilities
export const isWeb = typeof window !== 'undefined' && typeof window.document !== 'undefined';
export const isMobile = !isWeb;

// Storage adapter for different platforms
export interface StorageAdapter {
  getItem: (key: string) => Promise<string | null>;
  setItem: (key: string, value: string) => Promise<void>;
  removeItem: (key: string) => Promise<void>;
}

// Web storage adapter using localStorage
const webStorageAdapter: StorageAdapter = {
  getItem: async (key: string) => {
    if (typeof window === 'undefined') return null;
    return localStorage.getItem(key);
  },
  setItem: async (key: string, value: string) => {
    if (typeof window === 'undefined') return;
    localStorage.setItem(key, value);
  },
  removeItem: async (key: string) => {
    if (typeof window === 'undefined') return;
    localStorage.removeItem(key);
  },
};

// Mobile storage adapter (placeholder - would use AsyncStorage in mobile)
const mobileStorageAdapter: StorageAdapter = {
  getItem: async (key: string) => {
    // This would be AsyncStorage.getItem(key) in mobile
    return null;
  },
  setItem: async (key: string, value: string) => {
    // This would be AsyncStorage.setItem(key, value) in mobile
  },
  removeItem: async (key: string) => {
    // This would be AsyncStorage.removeItem(key) in mobile
  },
};

export const getStorageAdapter = (): StorageAdapter => {
  return isWeb ? webStorageAdapter : mobileStorageAdapter;
};
