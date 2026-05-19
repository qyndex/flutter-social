import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/social_models.dart';

part 'feed_provider.g.dart';

final _now = DateTime.now();

final _currentUser = AppProfile(
  id: 'me',
  username: 'me',
  fullName: 'You',
  bio: 'Flutter developer',
  avatarUrl: 'https://picsum.photos/seed/me/100/100',
  createdAt: _now.subtract(const Duration(days: 365)),
  followerCount: 142,
  followingCount: 98,
  postCount: 24,
);

final _sampleUsers = [
  AppProfile(
    id: 'u1',
    username: 'alice',
    fullName: 'Alice Chen',
    bio: 'Design enthusiast',
    avatarUrl: 'https://picsum.photos/seed/alice/100/100',
    createdAt: _now.subtract(const Duration(days: 700)),
    followerCount: 3400,
    followingCount: 210,
    postCount: 87,
  ),
  AppProfile(
    id: 'u2',
    username: 'bob',
    fullName: 'Bob Markov',
    bio: 'Backend engineer',
    avatarUrl: 'https://picsum.photos/seed/bob/100/100',
    createdAt: _now.subtract(const Duration(days: 500)),
    followerCount: 1200,
    followingCount: 450,
    postCount: 56,
  ),
  AppProfile(
    id: 'u3',
    username: 'carol',
    fullName: 'Carol Rivers',
    bio: 'Product manager',
    avatarUrl: 'https://picsum.photos/seed/carol/100/100',
    createdAt: _now.subtract(const Duration(days: 800)),
    followerCount: 5600,
    followingCount: 180,
    postCount: 143,
  ),
];

@riverpod
class Feed extends _$Feed {
  @override
  List<Post> build() {
    final now = DateTime.now();
    return [
      Post(
        id: 'p1',
        authorId: _sampleUsers[0].id,
        author: _sampleUsers[0],
        content:
            'Just shipped a new Flutter feature! The Material 3 dynamic color system is incredible.',
        createdAt: now.subtract(const Duration(minutes: 5)),
        likesCount: 142,
        commentCount: 23,
        isLiked: true,
      ),
      Post(
        id: 'p2',
        authorId: _sampleUsers[1].id,
        author: _sampleUsers[1],
        content:
            'GoRouter makes Flutter navigation so clean. Declarative routing FTW!',
        imageUrl: 'https://picsum.photos/seed/post2/600/400',
        createdAt: now.subtract(const Duration(hours: 1)),
        likesCount: 87,
        commentCount: 14,
      ),
      Post(
        id: 'p3',
        authorId: _sampleUsers[2].id,
        author: _sampleUsers[2],
        content:
            'Riverpod 2.x with code generation is the best state management solution I have used.',
        createdAt: now.subtract(const Duration(hours: 3)),
        likesCount: 256,
        commentCount: 41,
      ),
      Post(
        id: 'p4',
        authorId: _sampleUsers[0].id,
        author: _sampleUsers[0],
        content:
            'Exploring the new Impeller rendering engine. Performance gains are real.',
        imageUrl: 'https://picsum.photos/seed/post4/600/400',
        createdAt: now.subtract(const Duration(hours: 6)),
        likesCount: 198,
        commentCount: 32,
        isLiked: true,
      ),
    ];
  }

  void toggleLike(String postId) {
    state = [
      for (final post in state)
        if (post.id != postId)
          post
        else
          post.copyWith(
            isLiked: !post.isLiked,
            likesCount:
                post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
          ),
    ];
  }
}

final currentUserProvider = Provider<AppProfile>((ref) => _currentUser);

@riverpod
List<Conversation> conversations(Ref ref) {
  final now = DateTime.now();
  return [
    Conversation(
      id: 'c1',
      participant: _sampleUsers[0],
      lastMessage: 'Did you see the new Flutter docs?',
      lastMessageAt: now.subtract(const Duration(minutes: 10)),
      unreadCount: 2,
    ),
    Conversation(
      id: 'c2',
      participant: _sampleUsers[1],
      lastMessage: 'The PR is ready for review.',
      lastMessageAt: now.subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
    Conversation(
      id: 'c3',
      participant: _sampleUsers[2],
      lastMessage: 'Thanks for the feedback!',
      lastMessageAt: now.subtract(const Duration(days: 1)),
      unreadCount: 1,
    ),
  ];
}
