import { API } from '../APIFetch';
import type { ServerReview } from '../types';

export class ReviewService {
  static async getMovieReviews(movieId: string): Promise<ServerReview[]> {
    const response = await API.get(`/movies/${movieId}/reviews`);
    return response.data;
  }

  static async getUserReviews(userId: string): Promise<ServerReview[]> {
    const response = await API.get(`/users/${userId}/reviews`);
    return response.data;
  }

  static async createReview(
    movieId: string,
    rating: number,
    review?: string,
  ): Promise<ServerReview> {
    const response = await API.post('/reviews', { movieId, rating, review });
    return response.data;
  }

  static async updateReview(
    id: string,
    updates: { rating?: number; review?: string },
  ): Promise<ServerReview> {
    const response = await API.patch(`/reviews/${id}`, updates);
    return response.data;
  }

  static async deleteReview(id: string): Promise<void> {
    await API.delete(`/reviews/${id}`);
  }
}
