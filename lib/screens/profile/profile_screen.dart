import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: user == null
          ? const Center(child: Text('Не авторизован'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(radius: 40, backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null),
                  const SizedBox(height: 16),
                  Text(user.username, style: const TextStyle(fontSize: 24)),
                  Text(user.email),
                  const SizedBox(height: 8),
                  Text('Репутация: ${user.reputation}'),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Редактировать профиль'),
                    onTap: () {
                      //TODO сделать преход на экран редактирования профиля
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Выйти'),
                    onTap: () => ref.read(authStateProvider.notifier).logout(),
                  ),
                ],
              ),
            ),
    );
  }
}