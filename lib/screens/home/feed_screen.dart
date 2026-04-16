import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../widgets/feed_post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Лента')),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')),
        data: (posts) => RefreshIndicator(
          onRefresh: () => ref.refresh(feedProvider.future),
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (ctx, i) => FeedPostCard(post: posts[i]),
          ),
        ),
      ),
    );
  }
}