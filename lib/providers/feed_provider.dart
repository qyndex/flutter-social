import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/social_models.dart';

part 'feed_provider.g.dart';

final _currentUser = User(
  id: 'me', username: 'me', displayName: 'You',
  bio: 'Flutter developer', avatarUrl: 'https://picsum.photos/seed/me/100/100',
  followerCount: 142, followingCount: 98, postCount: 24, isFollowing: false,
);

final _sampleUsers = [
  User(id: 'u1', username: 'alice', displayName: 'Alice Chen',
      bio: 'Design enthusiast', avatarUrl: 'https://picsum.photos/seed/alice/100/100',
      followerCount: 3400, followingCount: 210, postCount: 87, isFollowing: true),
  User(id: 'u2', username: 'bob', displayName: 'Bob Markov',
      bio: 'Backend engineer', avatarUrl: 'https://picsum.photos/seed/bob/100/100',
      followerCount: 1200, followingCount: 450, postCount: 56, isFollowing: false),
  User(id: 'u3', username: 'carol', displayName: 'Carol Rivers',
      bio: 'Product manager', avatarUrl: 'https://picsum.photos/seed/carol/100/100',
      followerCount: 5600, followingCount: 180, postCount: 143, isFollowing: true),
];

@riverpod
class Feed extends _$Feed {
  @override
  List<Post> build() {
    final now = DateTime.now();
    return [
      Post(id: 'p1', author: _sampleUsers[0], content: 'Just shipped a new Flutter feature! The Material 3 dynamic color system is incredible.', createdAt: now.subtract(const Duration(minutes: 5)), likeCount: 142, commentCount: 23, isLiked: true),
      Post(id: 'p2', author: _sampleUsers[1], content: 'GoRouter makes Flutter navigation so clean. Declarative routing FTW!', imageUrl: 'https://picsum.photos/seed/post2/600/400', createdAt: now.subtract(const Duration(hours: 1)), likeCount: 87, commentCount: 14, isLiked: false),
      Post(id: 'p3', author: _sampleUsers[2], content: 'Riverpod 2.x with code generation is the best state management solution I have used.', createdAt: now.subtract(const Duration(hours: 3)), likeCount: 256, commentCount: 41, isLiked: false),
      Post(id: 'p4', author: _sampleUsers[0], content: 'Exploring the new Impeller rendering engine. Performance gains are real.', imageUrl: 'https://picsum.photos/seed/post4/600/400', createdAt: now.subtract(const Duration(hours: 6)), likeCount: 198, commentCount: 32, isLiked: true),
    ];
  }

  void toggleLike(String postId) {
    state = state.map((post) {
      if (post.id != postId) return post;
      return Post(
        id: post.id, author: post.author, content: post.content,
        imageUrl: post.imageUrl, createdAt: post.createdAt,
        likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
        commentCount: post.commentCount, isLiked: !post.isLiked,
      );
    }).toList();
  }
}

final currentUserProvider = Provider<User>((ref) => _currentUser);

@riverpod
List<Conversation> conversations(Ref ref) {
  final now = DateTime.now();
  return [
    Conversation(id: 'c1', participant: _sampleUsers[0], lastMessage: 'Did you see the new Flutter docs?', lastMessageAt: now.subtract(const Duration(minutes: 10)), unreadCount: 2),
    Conversation(id: 'c2', participant: _sampleUsers[1], lastMessage: 'The PR is ready for review.', lastMessageAt: now.subtract(const Duration(hours: 2)), unreadCount: 0),
    Conversation(id: 'c3', participant: _sampleUsers[2], lastMessage: 'Thanks for the feedback!', lastMessageAt: now.subtract(const Duration(days: 1)), unreadCount: 1),
  ];
}
