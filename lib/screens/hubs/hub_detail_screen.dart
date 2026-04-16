import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../widgets/hub_post_card.dart';

class HubDetailScreen extends ConsumerStatefulWidget {
  final String hubId;
  const HubDetailScreen({super.key, required this.hubId});

  @override
  ConsumerState<HubDetailScreen> createState() => _HubDetailScreenState();
}

class _HubDetailScreenState extends ConsumerState<HubDetailScreen> {
  final TextEditingController _postController = TextEditingController();
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    _loadHubInfo();
  }

  Future<void> _loadHubInfo() async {
    final hubService = ref.read(hubServiceProvider);
    final hub = await hubService.getHub(widget.hubId);
    // Проверить, состоит ли пользователь в хабе (может быть поле в Hub)
    setState(() {
      // _isMember = hub.isMember;
    });
  }

  Future<void> _toggleMembership() async {
    final hubService = ref.read(hubServiceProvider);
    if (_isMember) {
      await hubService.leaveHub(widget.hubId);
    } else {
      await hubService.joinHub(widget.hubId);
    }
    setState(() => _isMember = !_isMember);
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) return;
    final hubService = ref.read(hubServiceProvider);
    await hubService.createPost(widget.hubId, _postController.text.trim());
    _postController.clear();
    ref.invalidate(hubPostsProvider(widget.hubId));
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(hubPostsProvider(widget.hubId));
    return Scaffold(
      appBar: AppBar(title: const Text('Хаб')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text('Информация о хабе')),
                ElevatedButton(
                  onPressed: _toggleMembership,
                  child: Text(_isMember ? 'Покинуть' : 'Вступить'),
                ),
              ],
            ),
          ),
          if (_isMember)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: const InputDecoration(hintText: 'Напишите пост...'),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _createPost),
                ],
              ),
            ),
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (posts) => ListView.builder(
                itemCount: posts.length,
                itemBuilder: (ctx, i) => HubPostCard(post: posts[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Провайдер для постов хаба
final hubPostsProvider = FutureProvider.family<List<HubPost>, String>((ref, hubId) {
  return ref.watch(hubServiceProvider).getHubPosts(hubId);
});