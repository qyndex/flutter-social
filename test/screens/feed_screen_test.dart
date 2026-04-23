import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social/screens/feed_screen.dart';
import 'package:flutter_social/widgets/post_card.dart';

Widget _buildTestWidget() {
  final router = GoRouter(
    initialLocation: '/feed',
    routes: [
      GoRoute(
        path: '/feed',
        builder: (_, __) => const FeedScreen(),
      ),
      GoRoute(
        path: '/post/:id',
        builder: (_, state) => Scaffold(
          body: Text('Post ${state.pathParameters['id']}'),
        ),
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
  group('FeedScreen', () {
    testWidgets('displays Feed app bar title', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Feed'), findsOneWidget);
    });

    testWidgets('shows search icon in app bar', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows floating action button with edit icon', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('displays PostCard widgets for each post', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      // The feed provider produces 4 posts
      expect(find.byType(PostCard), findsNWidgets(4));
    });

    testWidgets('contains a ListView', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('contains a RefreshIndicator', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('shows dividers between posts', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      // ListView.separated creates dividers between items (n-1 dividers for n items)
      expect(find.byType(Divider), findsNWidgets(3));
    });
  });
}
