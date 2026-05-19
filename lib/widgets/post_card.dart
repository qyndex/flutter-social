import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/social_models.dart';
import '../providers/feed_provider.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = post.author;
    final authorName = author?.fullName.isNotEmpty == true
        ? author!.fullName
        : (author?.username ?? 'Unknown');
    final authorHandle = author?.username ?? 'unknown';
    final authorAvatar = author?.avatarUrl ?? '';
    return InkWell(
      onTap: () => context.push('/post/${post.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.push('/user/${post.authorId}'),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: authorAvatar.isNotEmpty
                        ? NetworkImage(authorAvatar)
                        : null,
                    child: authorAvatar.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('@$authorHandle',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(post.imageUrl!, height: 200, width: double.infinity,
                    fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 10),
            Row(children: [
              IconButton(
                icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null),
                onPressed: () => ref.read(feedProvider.notifier).toggleLike(post.id),
              ),
              Text('${post.likesCount}'),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline, size: 20),
              const SizedBox(width: 4),
              Text('${post.commentCount}'),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 20),
            ]),
          ],
        ),
      ),
    );
  }
}
