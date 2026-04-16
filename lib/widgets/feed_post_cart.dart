import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/feed_post.dart';

class FeedPostCard extends StatelessWidget {
  final FeedPost post;
  const FeedPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(post.hubName[0])),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.hubName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(DateFormat.yMMMd().add_Hm().format(post.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                Text('${post.likes}'),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}