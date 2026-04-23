import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/providers/feed_provider.dart';
import 'package:flutter_social/models/social_models.dart';

void main() {
  group('feedProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('provides initial list of posts', () {
      final posts = container.read(feedProvider);
      expect(posts, isA<List<Post>>());
      expect(posts.length, 4);
    });

    test('initial posts have expected IDs', () {
      final posts = container.read(feedProvider);
      final ids = posts.map((p) => p.id).toList();
      expect(ids, ['p1', 'p2', 'p3', 'p4']);
    });

    test('posts have valid authors', () {
      final posts = container.read(feedProvider);
      for (final post in posts) {
        expect(post.author, isA<User>());
        expect(post.author.id, isNotEmpty);
        expect(post.author.username, isNotEmpty);
        expect(post.author.displayName, isNotEmpty);
      }
    });

    test('posts have non-negative like and comment counts', () {
      final posts = container.read(feedProvider);
      for (final post in posts) {
        expect(post.likeCount, greaterThanOrEqualTo(0));
        expect(post.commentCount, greaterThanOrEqualTo(0));
      }
    });

    test('some posts have images, some do not', () {
      final posts = container.read(feedProvider);
      final withImages = posts.where((p) => p.imageUrl != null).toList();
      final withoutImages = posts.where((p) => p.imageUrl == null).toList();
      expect(withImages, isNotEmpty);
      expect(withoutImages, isNotEmpty);
    });

    test('posts are ordered by createdAt descending (newest first)', () {
      final posts = container.read(feedProvider);
      for (int i = 0; i < posts.length - 1; i++) {
        expect(
          posts[i].createdAt.isAfter(posts[i + 1].createdAt),
          isTrue,
          reason: 'Post ${posts[i].id} should be newer than ${posts[i + 1].id}',
        );
      }
    });
  });

  group('feedProvider.notifier.toggleLike', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('toggles isLiked from true to false', () {
      final initialPosts = container.read(feedProvider);
      final likedPost = initialPosts.firstWhere((p) => p.isLiked);
      final originalLikeCount = likedPost.likeCount;

      container.read(feedProvider.notifier).toggleLike(likedPost.id);

      final updatedPosts = container.read(feedProvider);
      final updatedPost = updatedPosts.firstWhere((p) => p.id == likedPost.id);
      expect(updatedPost.isLiked, isFalse);
      expect(updatedPost.likeCount, originalLikeCount - 1);
    });

    test('toggles isLiked from false to true', () {
      final initialPosts = container.read(feedProvider);
      final unlikedPost = initialPosts.firstWhere((p) => !p.isLiked);
      final originalLikeCount = unlikedPost.likeCount;

      container.read(feedProvider.notifier).toggleLike(unlikedPost.id);

      final updatedPosts = container.read(feedProvider);
      final updatedPost =
          updatedPosts.firstWhere((p) => p.id == unlikedPost.id);
      expect(updatedPost.isLiked, isTrue);
      expect(updatedPost.likeCount, originalLikeCount + 1);
    });

    test('double toggle restores original state', () {
      final initialPosts = container.read(feedProvider);
      final post = initialPosts.first;
      final originalIsLiked = post.isLiked;
      final originalLikeCount = post.likeCount;

      container.read(feedProvider.notifier).toggleLike(post.id);
      container.read(feedProvider.notifier).toggleLike(post.id);

      final restored = container.read(feedProvider).firstWhere((p) => p.id == post.id);
      expect(restored.isLiked, originalIsLiked);
      expect(restored.likeCount, originalLikeCount);
    });

    test('toggling one post does not affect others', () {
      final initialPosts = container.read(feedProvider);
      final targetId = initialPosts.first.id;
      final othersBefore = initialPosts
          .where((p) => p.id != targetId)
          .map((p) => '${p.id}:${p.isLiked}:${p.likeCount}')
          .toList();

      container.read(feedProvider.notifier).toggleLike(targetId);

      final updatedPosts = container.read(feedProvider);
      final othersAfter = updatedPosts
          .where((p) => p.id != targetId)
          .map((p) => '${p.id}:${p.isLiked}:${p.likeCount}')
          .toList();
      expect(othersAfter, othersBefore);
    });

    test('toggling non-existent ID does not crash or change state', () {
      final before = container.read(feedProvider);
      container.read(feedProvider.notifier).toggleLike('nonexistent');
      final after = container.read(feedProvider);
      expect(after.length, before.length);
    });
  });

  group('currentUserProvider', () {
    test('provides a user with id "me"', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = container.read(currentUserProvider);
      expect(user, isA<User>());
      expect(user.id, 'me');
      expect(user.username, 'me');
      expect(user.displayName, 'You');
    });
  });

  group('conversationsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('provides a list of conversations', () {
      final conversations = container.read(conversationsProvider);
      expect(conversations, isA<List<Conversation>>());
      expect(conversations.length, 3);
    });

    test('conversations have valid participants', () {
      final conversations = container.read(conversationsProvider);
      for (final conv in conversations) {
        expect(conv.participant, isA<User>());
        expect(conv.participant.id, isNotEmpty);
        expect(conv.participant.displayName, isNotEmpty);
      }
    });

    test('conversations have last message text', () {
      final conversations = container.read(conversationsProvider);
      for (final conv in conversations) {
        expect(conv.lastMessage, isNotEmpty);
      }
    });

    test('some conversations have unread messages', () {
      final conversations = container.read(conversationsProvider);
      final withUnread = conversations.where((c) => c.unreadCount > 0);
      expect(withUnread, isNotEmpty);
    });
  });
}
