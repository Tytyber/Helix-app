import '../models/chat.dart';
import '../models/message.dart';
import 'api_client.dart';

class ChatService {
  final ApiClient _apiClient;
  ChatService(this._apiClient);

  Future<Chat> createChat(String userId) async {
    final res = await _apiClient.post('/protected/chats', data: {'user_id': userId});
    return Chat.fromJson(res.data);
  }

  Future<List<Message>> getMessages(String chatId, {int limit = 50, DateTime? before}) async {
    final query = {'limit': limit.toString()};
    if (before != null) query['before'] = before.toIso8601String();
    final res = await _apiClient.get('/protected/chats/$chatId/messages', queryParameters: query);
    return (res.data as List).map((json) => Message.fromJson(json)).toList();
  }

  Future<Message> sendMessage(String chatId, String content) async {
    final res = await _apiClient.post('/protected/chats/$chatId/messages', data: {'content': content});
    return Message.fromJson(res.data);
  }

  // Получить список чатов пользователя (если есть эндпоинт)
  Future<List<Chat>> getChats() async {
    final res = await _apiClient.get('/protected/chats');
    return (res.data as List).map((json) => Chat.fromJson(json)).toList();
  }
}