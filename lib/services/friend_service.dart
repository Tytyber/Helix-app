import '../models/friend.dart';
import 'api_client.dart';

class FriendService {
  final ApiClient _apiClient;
  FriendService(this._apiClient);

  Future<FriendRequest> sendFriendRequest(String userId) async {
    final res = await _apiClient.post('/protected/friends/request', data: {'user_id': userId});
    return FriendRequest.fromJson(res.data);
  }

  Future<FriendRequest> acceptFriendRequest(String requestId) async {
    final res = await _apiClient.post('/protected/friends/accept', data: {'request_id': requestId});
    return FriendRequest.fromJson(res.data);
  }

  Future<List<Friend>> getFriends() async {
    final res = await _apiClient.get('/protected/friends');
    return (res.data as List).map((json) => Friend.fromJson(json)).toList();
  }

  // Дополнительно: получить входящие заявки (если API предоставляет)
  Future<List<FriendRequest>> getPendingRequests() async {
    // Предположим, что эндпоинт существует или нужно добавить
    final res = await _apiClient.get('/protected/friends/requests/pending');
    return (res.data as List).map((json) => FriendRequest.fromJson(json)).toList();
  }
}