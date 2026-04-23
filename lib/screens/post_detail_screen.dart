import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedProvider);
    final post = posts.where((p) => p.id == postId).firstOrNull;

    if (post == null) {
      return const Scaffold(body: Center(child: Text('Post not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostCard(post: post),
            const Divider(),
            const ListTile(title: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold))),
            ...List.generate(
              post.commentCount.clamp(0, 5),
              (i) => ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text('User ${i + 1}'),
                subtitle: Text('Great post! Really enjoyed reading this. #${i + 1}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
