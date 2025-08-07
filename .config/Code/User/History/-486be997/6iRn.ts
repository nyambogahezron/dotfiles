import { API } from '../APIFetch';
import type { LoginRequest, RegisterRequest, ServerUser } from '../types';

export class AuthService {
  static async login(credentials: LoginRequest) {
    const response = await API.post('/auth/login', credentials);
    return response.data;
  }

  static async register(userData: RegisterRequest) {
    const response = await API.post('/auth/register', userData);
    return response.data;
  }

  static async getCurrentUser(): Promise<ServerUser> {
    const response = await API.get('/auth/me');
    return response.data;
  }

  static async requestPasswordReset(email: string) {
    const response = await API.post('/auth/request-password-reset', { email });
    return response.data;
  }

  static async resetPassword(token: string, newPassword: string) {
    const response = await API.post('/auth/reset-password', { token, newPassword });
    return response.data;
  }

  static async logout() {
    await API.post('/auth/logout');
  }
}
