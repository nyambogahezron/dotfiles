import { API } from '../APIFetch';
import type { ServerFavorite } from '../types';

export class FavoriteService {
  static async getUserFavorites(userId: string): Promise<ServerFavorite[]> {
    const response = await API.get(`/users/${userId}/favorites`);
    return response.data;
  }

  static async addToFavorites(movieId: string): Promise<ServerFavorite> {
    const response = await API.post('/favorites', { movieId });
    return response.data;
  }

  static async removeFromFavorites(id: string): Promise<void> {
    await API.delete(`/favorites/${id}`);
  }
}
