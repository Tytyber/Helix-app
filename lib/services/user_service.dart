import '../models/user.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient;
  UserService(this._apiClient);

  Future<User> updateProfile({String? username, String? bio, String? avatarUrl}) async {
    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (bio != null) data['bio'] = bio;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    final res = await _apiClient.put('/protected/profile', data: data);
    return User.fromJson(res.data);
  }

  Future<void> addReputation(String userId) async {
    await _apiClient.post('/protected/reputation', data: {'user_id': userId});
  }
}