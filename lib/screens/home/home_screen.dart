import 'package:flutter/material.dart';

/// Заглушка для HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Перенаправляем на FeedScreen, так как это основной контент ленты
    return const FeedScreen();
  }
}
import 'feed_screen.dart';