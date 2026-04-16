import 'package:riverpod/riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/hub_service.dart';
import '../models/user.dart';

//  провайдеры
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
final apiClientProvider = Provider((ref) => ApiClient());
final authServiceProvider = Provider((ref) => AuthService(ref.watch(apiClientProvider)));
final hubServiceProvider = Provider((ref) => HubService(ref.watch(apiClientProvider)));
final authStateProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());
final feedServiceProvider = Provider((ref) => FeedService(ref.watch(apiClientProvider)));
final friendServiceProvider = Provider((ref) => FriendService(ref.watch(apiClientProvider)));
final groupServiceProvider = Provider((ref) => GroupService(ref.watch(apiClientProvider)));
final chatServiceProvider = Provider((ref) => ChatService(ref.watch(apiClientProvider)));
final callServiceProvider = Provider((ref) => CallService(ref.watch(apiClientProvider)));
final userServiceProvider = Provider((ref) => UserService(ref.watch(apiClientProvider)));

final feedProvider = FutureProvider<List<FeedPost>>((ref) {
  return ref.watch(feedServiceProvider).getFeed();
});

final topHubsProvider = FutureProvider<List<TopHub>>((ref) {
  return ref.watch(feedServiceProvider).getTopHubs();
});

final friendsProvider = FutureProvider<List<Friend>>((ref) {
  return ref.watch(friendServiceProvider).getFriends();
});

final chatsProvider = FutureProvider<List<Chat>>((ref) {
  return ref.watch(chatServiceProvider).getChats();
});

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, AsyncValue<List<Message>>, String>((ref, chatId) {
  return ChatMessagesNotifier(chatId, ref.watch(chatServiceProvider));
});



class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final authService = ref.read(authServiceProvider);
    return await authService.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      return await authService.login(email, password);
    });
  }

  Future<void> register(String username, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      return await authService.register(username, email, password);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
    });
    state = const AsyncData(null);
  }
}

final hubsProvider = FutureProvider<List<Hub>>((ref) async {
  final hubService = ref.watch(hubServiceProvider);
  return hubService.getHubs();
});

class ChatMessagesNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final String chatId;
  final ChatService _chatService;
  Timer? _timer;

  ChatMessagesNotifier(this.chatId, this._chatService) : super(const AsyncLoading()) {
    _startPolling();
  }

  void _startPolling() {
    _fetchMessages();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchMessages());
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _chatService.getMessages(chatId);
      if (mounted) {
        state = AsyncData(messages);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      await _chatService.sendMessage(chatId, content);
      // После отправки сразу обновим список
      await _fetchMessages();
    } catch (e) {
      // Обработка ошибки
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Аналогично для групп
final groupMessagesProvider = StateNotifierProvider.family<GroupMessagesNotifier, AsyncValue<List<GroupMessage>>, String>((ref, groupId) {
  return GroupMessagesNotifier(groupId, ref.watch(groupServiceProvider));
});

class GroupMessagesNotifier extends StateNotifier<AsyncValue<List<GroupMessage>>> {
  final String groupId;
  final GroupService _groupService;
  Timer? _timer;

  GroupMessagesNotifier(this.groupId, this._groupService) : super(const AsyncLoading()) {
    _startPolling();
  }

  void _startPolling() {
    _fetchMessages();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchMessages());
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _groupService.getMessages(groupId);
      if (mounted) state = AsyncData(messages);
    } catch (e, st) {
      if (mounted) state = AsyncError(e, st);
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      await _groupService.sendMessage(groupId, content);
      await _fetchMessages();
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}