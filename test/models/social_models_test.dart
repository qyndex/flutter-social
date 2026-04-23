import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_social/models/social_models.dart';

void main() {
  group('User', () {
    test('constructs with all required fields', () {
      const user = User(
        id: 'u1',
        username: 'alice',
        displayName: 'Alice Chen',
        bio: 'Design enthusiast',
        avatarUrl: 'https://example.com/avatar.png',
        followerCount: 100,
        followingCount: 50,
        postCount: 10,
        isFollowing: true,
      );

      expect(user.id, 'u1');
      expect(user.username, 'alice');
      expect(user.displayName, 'Alice Chen');
      expect(user.bio, 'Design enthusiast');
      expect(user.avatarUrl, 'https://example.com/avatar.png');
      expect(user.followerCount, 100);
      expect(user.followingCount, 50);
      expect(user.postCount, 10);
      expect(user.isFollowing, isTrue);
    });

    test('supports const construction', () {
      const user1 = User(
        id: 'u1',
        username: 'test',
        displayName: 'Test',
        bio: '',
        avatarUrl: '',
        followerCount: 0,
        followingCount: 0,
        postCount: 0,
        isFollowing: false,
      );
      const user2 = User(
        id: 'u1',
        username: 'test',
        displayName: 'Test',
        bio: '',
        avatarUrl: '',
        followerCount: 0,
        followingCount: 0,
        postCount: 0,
        isFollowing: false,
      );
      // Const instances with same values are identical.
      expect(identical(user1, user2), isTrue);
    });
  });

  group('Post', () {
    test('constructs with required fields and optional imageUrl', () {
      final now = DateTime.now();
      const author = User(
        id: 'u1',
        username: 'bob',
        displayName: 'Bob',
        bio: '',
        avatarUrl: '',
        followerCount: 0,
        followingCount: 0,
        postCount: 0,
        isFollowing: false,
      );

      final post = Post(
        id: 'p1',
        author: author,
        content: 'Hello world',
        createdAt: now,
        likeCount: 5,
        commentCount: 2,
        isLiked: false,
      );

      expect(post.id, 'p1');
      expect(post.author, author);
      expect(post.content, 'Hello world');
      expect(post.imageUrl, isNull);
      expect(post.createdAt, now);
      expect(post.likeCount, 5);
      expect(post.commentCount, 2);
      expect(post.isLiked, isFalse);
    });

    test('accepts imageUrl', () {
      final post = Post(
        id: 'p2',
        author: const User(
          id: 'u1',
          username: 'a',
          displayName: 'A',
          bio: '',
          avatarUrl: '',
          followerCount: 0,
          followingCount: 0,
          postCount: 0,
          isFollowing: false,
        ),
        content: 'With image',
        imageUrl: 'https://example.com/image.jpg',
        createdAt: DateTime(2024, 1, 1),
        likeCount: 0,
        commentCount: 0,
        isLiked: true,
      );

      expect(post.imageUrl, 'https://example.com/image.jpg');
      expect(post.isLiked, isTrue);
    });
  });

  group('Message', () {
    test('constructs with all fields', () {
      final sentAt = DateTime(2024, 6, 15, 10, 30);
      final msg = Message(
        id: 'm1',
        senderId: 'u1',
        content: 'Hello!',
        sentAt: sentAt,
        isRead: true,
      );

      expect(msg.id, 'm1');
      expect(msg.senderId, 'u1');
      expect(msg.content, 'Hello!');
      expect(msg.sentAt, sentAt);
      expect(msg.isRead, isTrue);
    });

    test('unread message', () {
      final msg = Message(
        id: 'm2',
        senderId: 'u2',
        content: 'Unread',
        sentAt: DateTime.now(),
        isRead: false,
      );
      expect(msg.isRead, isFalse);
    });
  });

  group('Conversation', () {
    test('constructs with participant and unread count', () {
      const participant = User(
        id: 'u1',
        username: 'alice',
        displayName: 'Alice',
        bio: '',
        avatarUrl: '',
        followerCount: 0,
        followingCount: 0,
        postCount: 0,
        isFollowing: false,
      );
      final conv = Conversation(
        id: 'c1',
        participant: participant,
        lastMessage: 'See you later!',
        lastMessageAt: DateTime(2024, 6, 15),
        unreadCount: 3,
      );

      expect(conv.id, 'c1');
      expect(conv.participant, participant);
      expect(conv.lastMessage, 'See you later!');
      expect(conv.unreadCount, 3);
    });

    test('zero unread count for read conversations', () {
      final conv = Conversation(
        id: 'c2',
        participant: const User(
          id: 'u2',
          username: 'bob',
          displayName: 'Bob',
          bio: '',
          avatarUrl: '',
          followerCount: 0,
          followingCount: 0,
          postCount: 0,
          isFollowing: false,
        ),
        lastMessage: 'All caught up',
        lastMessageAt: DateTime.now(),
        unreadCount: 0,
      );
      expect(conv.unreadCount, 0);
    });
  });
}
