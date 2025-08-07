import { API } from '../APIFetch';
import type { ServerMovie } from '../types';

export class MovieService {
  static async getMovie(id: string): Promise<ServerMovie> {
    const response = await API.get(`/movies/${id}`);
    return response.data;
  }

  static async searchMovies(query: string): Promise<ServerMovie[]> {
    const response = await API.get(`/movies/search?q=${encodeURIComponent(query)}`);
    return response.data;
  }

  static async getTrendingMovies(): Promise<ServerMovie[]> {
    const response = await API.get('/movies/trending');
    return response.data;
  }

  static async getPopularMovies(): Promise<ServerMovie[]> {
    const response = await API.get('/movies/popular');
    return response.data;
  }

  static async getUserMovies(userId: string): Promise<ServerMovie[]> {
    const response = await API.get(`/users/${userId}/movies`);
    return response.data;
  }
}
