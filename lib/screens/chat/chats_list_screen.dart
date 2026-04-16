import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/chat_list_tile.dart';

class ChatsListScreen extends ConsumerWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Чаты')),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (chats) => ListView.builder(
          itemCount: chats.length,
          itemBuilder: (ctx, i) {
            final chat = chats[i];
            return ChatListTile(
              chat: chat,
              onTap: () => context.go('/chats/${chat.id}'),
            );
          },
        ),
      ),
    );
  }
}