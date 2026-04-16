import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this._apiClient);

  Future<User> register(String username, String email, String password) async {
    final response = await _apiClient.post('/auth/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    await _saveTokens(response.data['access_token'], response.data['refresh_token']);
    return User.fromJson(response.data['user']);
  }

  Future<User> login(String email, String password) async {
    final response = await _apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    await _saveTokens(response.data['access_token'], response.data['refresh_token']);
    return User.fromJson(response.data['user']);
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/protected/me');
      return User.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }
}