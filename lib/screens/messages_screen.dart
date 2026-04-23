import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/feed_provider.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final conv = conversations[index];
          return ListTile(
            leading: Badge(
              label: Text('${conv.unreadCount}'),
              isLabelVisible: conv.unreadCount > 0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(conv.participant.avatarUrl),
              ),
            ),
            title: Row(children: [
              Text(conv.participant.displayName,
                  style: TextStyle(
                    fontWeight: conv.unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              const Spacer(),
              Text(
                _formatTime(conv.lastMessageAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]),
            subtitle: Text(
              conv.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: conv.unreadCount > 0 ? FontWeight.w600 : null,
              ),
            ),
            onTap: () => context.push('/conversation/${conv.id}'),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
