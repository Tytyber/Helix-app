import '../models/hub.dart';
import '../models/hub_post.dart';
import 'api_client.dart';

class HubService {
  final ApiClient _apiClient;

  HubService(this._apiClient);

  Future<List<Hub>> getHubs() async {
    final response = await _apiClient.get('/protected/hubs');
    return (response.data as List).map((json) => Hub.fromJson(json)).toList();
  }

  Future<Hub> getHub(String id) async {
    final response = await _apiClient.get('/protected/hubs/$id');
    return Hub.fromJson(response.data);
  }

  Future<void> joinHub(String id) => _apiClient.post('/protected/hubs/$id/join');

  Future<void> leaveHub(String id) => _apiClient.post('/protected/hubs/$id/leave');

  Future<List<HubPost>> getHubPosts(String hubId) async {
    final response = await _apiClient.get('/protected/hubs/$hubId/posts');
    return (response.data as List).map((json) => HubPost.fromJson(json)).toList();
  }

  Future<HubPost> createPost(String hubId, String content) async {
    final response = await _apiClient.post('/protected/hubs/$hubId/posts', data: {
      'content': content,
    });
    return HubPost.fromJson(response.data);
  }
}