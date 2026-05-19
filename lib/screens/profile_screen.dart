import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final feed = ref.watch(feedProvider);
    final myPosts = feed.where((p) => p.authorId == user.id).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    const Spacer(),
                    OutlinedButton(onPressed: () {}, child: const Text('Edit Profile')),
                  ]),
                  const SizedBox(height: 12),
                  Text(user.fullName.isNotEmpty ? user.fullName : user.username,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('@${user.username}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Text(user.bio),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _Stat(label: 'Posts', value: '${user.postCount}'),
                    _Stat(label: 'Followers', value: '${user.followerCount}'),
                    _Stat(label: 'Following', value: '${user.followingCount}'),
                  ]),
                ],
              ),
            ),
          ),
          if (myPosts.isEmpty)
            const SliverToBoxAdapter(
              child: Center(child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No posts yet'),
              )),
            )
          else
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Center(child: Icon(Icons.image, size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
                childCount: myPosts.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold)),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
