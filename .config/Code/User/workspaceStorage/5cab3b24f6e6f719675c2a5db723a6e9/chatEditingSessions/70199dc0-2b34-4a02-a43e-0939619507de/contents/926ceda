import { API } from '../APIFetch';
import type { ServerWatchlist } from '../types';

export class WatchlistService {
  static async getUserWatchlist(userId: string): Promise<ServerWatchlist[]> {
    const response = await API.get(`/users/${userId}/watchlist`);
    return response.data;
  }

  static async addToWatchlist(movieId: string, status: string): Promise<ServerWatchlist> {
    const response = await API.post('/watchlist', { movieId, status });
    return response.data;
  }

  static async updateWatchlistItem(id: string, updates: Partial<ServerWatchlist>): Promise<ServerWatchlist> {
    const response = await API.patch(`/watchlist/${id}`, updates);
    return response.data;
  }

  static async removeFromWatchlist(id: string): Promise<void> {
    await API.delete(`/watchlist/${id}`);
  }
}
