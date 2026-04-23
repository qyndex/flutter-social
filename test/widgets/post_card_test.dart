import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social/widgets/post_card.dart';
import 'package:flutter_social/models/social_models.dart';
import 'package:flutter_social/providers/feed_provider.dart';

const _testUser = User(
  id: 'u1',
  username: 'testuser',
  displayName: 'Test User',
  bio: 'A test user',
  avatarUrl: 'https://example.com/avatar.png',
  followerCount: 100,
  followingCount: 50,
  postCount: 10,
  isFollowing: false,
);

Widget _buildTestWidget({
  required Post post,
  List<String>? navigatedPaths,
}) {
  final router = GoRouter(
    initialLocation: '/feed',
    routes: [
      GoRoute(
        path: '/feed',
        builder: (_, __) => Scaffold(
          body: SingleChildScrollView(child: PostCard(post: post)),
        ),
      ),
      GoRoute(
        path: '/post/:id',
        builder: (_, state) {
          navigatedPaths?.add('/post/${state.pathParameters['id']}');
          return const Scaffold(body: Text('Post Detail'));
        },
      ),
      GoRoute(
        path: '/user/:id',
        builder: (_, state) {
          navigatedPaths?.add('/user/${state.pathParameters['id']}');
          return const Scaffold(body: Text('User Profile'));
        },
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('PostCard', () {
    final basePost = Post(
      id: 'p1',
      author: _testUser,
      content: 'Hello world! This is a test post.',
      createdAt: DateTime(2024, 6, 15, 10, 30),
      likeCount: 42,
      commentCount: 7,
      isLiked: false,
    );

    testWidgets('displays author display name', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('displays author username with @ prefix', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.text('@testuser'), findsOneWidget);
    });

    testWidgets('displays post content', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.text('Hello world! This is a test post.'), findsOneWidget);
    });

    testWidgets('displays like count', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('displays comment count', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('shows unfilled heart when not liked', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('shows filled heart when liked', (tester) async {
      final likedPost = Post(
        id: 'p1',
        author: _testUser,
        content: 'Liked post',
        createdAt: DateTime(2024, 6, 15),
        likeCount: 10,
        commentCount: 0,
        isLiked: true,
      );

      await tester.pumpWidget(_buildTestWidget(post: likedPost));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('shows comment bubble icon', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });

    testWidgets('shows share icon', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets('shows more options icon', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('does not show image when imageUrl is null', (tester) async {
      await tester.pumpWidget(_buildTestWidget(post: basePost));
      await tester.pumpAndSettle();

      // No Image.network should appear for the post image
      // (avatar uses NetworkImage via CircleAvatar, not Image.network)
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows image when imageUrl is provided', (tester) async {
      final postWithImage = Post(
        id: 'p2',
        author: _testUser,
        content: 'Post with image',
        imageUrl: 'https://example.com/photo.jpg',
        createdAt: DateTime(2024, 6, 15),
        likeCount: 5,
        commentCount: 1,
        isLiked: false,
      );

      await tester.pumpWidget(_buildTestWidget(post: postWithImage));
      await tester.pumpAndSettle();

      // Image.network is used for the post image
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('tapping card navigates to post detail', (tester) async {
      final paths = <String>[];
      await tester.pumpWidget(
          _buildTestWidget(post: basePost, navigatedPaths: paths));
      await tester.pumpAndSettle();

      // Tap the InkWell (the card body)
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(paths, contains('/post/p1'));
    });

    testWidgets('tapping avatar navigates to user profile', (tester) async {
      final paths = <String>[];
      await tester.pumpWidget(
          _buildTestWidget(post: basePost, navigatedPaths: paths));
      await tester.pumpAndSettle();

      // Tap the GestureDetector wrapping the avatar
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(paths, contains('/user/u1'));
    });
  });
}
