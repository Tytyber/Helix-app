import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../widgets/hub_card.dart';

class HubsScreen extends ConsumerWidget {
  const HubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubsAsync = ref.watch(hubsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Хабы')),
      body: hubsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
        data: (hubs) => RefreshIndicator(
          onRefresh: () => ref.refresh(hubsProvider.future),
          child: ListView.builder(
            itemCount: hubs.length,
            itemBuilder: (context, index) {
              final hub = hubs[index];
              return HubCard(
                hub: hub,
                onTap: () => context.go('/hubs/${hub.id}'),
              );
            },
          ),
        ),
      ),
    );
  }
}