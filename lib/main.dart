import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/providers.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/hubs/hubs_screen.dart';
import 'screens/hubs/hub_detail_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final router = GoRouter(
      redirect: (context, state) {
        final isLoggedIn = authState.value != null;
        final isLoggingIn = authState.isLoading;

        if (isLoggingIn) return null;

        final isGoingToAuth = state.matchedLocation.startsWith('/login') ||
            state.matchedLocation.startsWith('/register');

        if (!isLoggedIn && !isGoingToAuth) {
          return '/login';
        }
        if (isLoggedIn && isGoingToAuth) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return HomeShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const FeedScreen(),
            ),
            GoRoute(
              path: '/hubs',
              builder: (context, state) => const HubsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return HubDetailScreen(hubId: id);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/chats/:chatId',
              builder: (context, state) {
                final chatId = state.pathParameters['chatId']!;
                return ChatScreen(chatId: chatId);
              },
            ),
            // Остальные маршруты...
          ],
        ),
      ],
      errorBuilder: (context, state) => const Scaffold(
        body: Center(child: Text('Страница не найдена')),
      ),
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Messenger',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

// Оболочка с BottomNavigationBar
class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/hubs');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Лента'),
          BottomNavigationBarItem(icon: Icon(Icons.hub), label: 'Хабы'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чаты'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/hubs')) return 1;
    if (location.startsWith('/chats')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}