import '../models/feed_post.dart';
import '../models/top_hub.dart';
import 'api_client.dart';

class FeedService {
  final ApiClient _apiClient;
  FeedService(this._apiClient);

  Future<List<FeedPost>> getFeed() async {
    final res = await _apiClient.get('/protected/feed');
    return (res.data as List).map((json) => FeedPost.fromJson(json)).toList();
  }

  Future<List<TopHub>> getTopHubs() async {
    final res = await _apiClient.get('/protected/feed/top-hubs');
    return (res.data as List).map((json) => TopHub.fromJson(json)).toList();
  }
}