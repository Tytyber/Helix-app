import '../models/group.dart';
import '../models/group_message.dart';
import 'api_client.dart';

class GroupService {
  final ApiClient _apiClient;
  GroupService(this._apiClient);

  Future<Group> createGroup(String name) async {
    final res = await _apiClient.post('/protected/groups', data: {'name': name});
    return Group.fromJson(res.data);
  }

  Future<void> joinGroup(String groupId) => _apiClient.post('/protected/groups/$groupId/join');

  Future<void> leaveGroup(String groupId) => _apiClient.post('/protected/groups/$groupId/leave');

  Future<List<GroupMessage>> getMessages(String groupId, {int limit = 50, DateTime? before}) async {
    final query = {'limit': limit.toString()};
    if (before != null) query['before'] = before.toIso8601String();
    final res = await _apiClient.get('/protected/groups/$groupId/messages', queryParameters: query);
    return (res.data as List).map((json) => GroupMessage.fromJson(json)).toList();
  }

  Future<GroupMessage> sendMessage(String groupId, String content) async {
    final res = await _apiClient.post('/protected/groups/$groupId/messages', data: {'content': content});
    return GroupMessage.fromJson(res.data);
  }
}