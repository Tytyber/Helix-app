import 'package:flutter/material.dart';

/// Заглушка для виджета элемента списка чатов
/// Отображает основную информацию о чате
/// В будущем будет обновлен для отображения последнего сообщения и времени

class ChatListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ChatListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  factory ChatListTile.fromChat(Map<String, dynamic> chat, {VoidCallback? onTap}) {
    return ChatListTile(
      title: chat['name'] ?? 'Чат',
      subtitle: chat['lastMessage']?['text'] ?? 'Нет сообщений',
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
      trailing: trailing,
    );
  }
}