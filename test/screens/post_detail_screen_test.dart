import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social/screens/post_detail_screen.dart';
import 'package:flutter_social/widgets/post_card.dart';

Widget _buildTestWidget({String postId = 'p1'}) {
  final router = GoRouter(
    initialLocation: '/post/$postId',
    routes: [
      GoRoute(
        path: '/post/:id',
        builder: (_, state) =>
            PostDetailScreen(postId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/user/:id',
        builder: (_, state) => Scaffold(
          body: Text('User ${state.pathParameters['id']}'),
        ),
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('PostDetailScreen', () {
    testWidgets('displays Post app bar title', (tester) async {
      await tester.pumpWidget(_buildTestWidget(postId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('shows PostCard for existing post', (tester) async {
      await tester.pumpWidget(_buildTestWidget(postId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.byType(PostCard), findsOneWidget);
    });

    testWidgets('shows Comments heading', (tester) async {
      await tester.pumpWidget(_buildTestWidget(postId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.text('Comments'), findsOneWidget);
    });

    testWidgets('shows "Post not found" for unknown post ID', (tester) async {
      await tester.pumpWidget(_buildTestWidget(postId: 'nonexistent'));
      await tester.pumpAndSettle();

      expect(find.text('Post not found'), findsOneWidget);
    });

    testWidgets('shows comment list items for post with comments',
        (tester) async {
      // Post p1 has commentCount=23, clamped to 5 in the UI
      await tester.pumpWidget(_buildTestWidget(postId: 'p1'));
      await tester.pumpAndSettle();

      // Should show 5 comment entries (clamp of 23)
      expect(find.text('User 1'), findsOneWidget);
      expect(find.text('User 5'), findsOneWidget);
    });

    testWidgets('has a SingleChildScrollView for scrollable content',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget(postId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows a Divider between post and comments', (tester) async {
      await tester.pumpWidget(_buildTestWidget(postId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsWidgets);
    });
  });
}
