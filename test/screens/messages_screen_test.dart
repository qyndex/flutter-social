import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social/screens/messages_screen.dart';

Widget _buildTestWidget() {
  final router = GoRouter(
    initialLocation: '/messages',
    routes: [
      GoRoute(
        path: '/messages',
        builder: (_, __) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/conversation/:id',
        builder: (_, state) => Scaffold(
          body: Text('Conversation ${state.pathParameters['id']}'),
        ),
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('MessagesScreen', () {
    testWidgets('displays Messages app bar title', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Messages'), findsOneWidget);
    });

    testWidgets('shows compose icon in app bar', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('displays conversation list tiles', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      // 3 conversations from provider
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('shows participant display names', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Alice Chen'), findsOneWidget);
      expect(find.text('Bob Markov'), findsOneWidget);
      expect(find.text('Carol Rivers'), findsOneWidget);
    });

    testWidgets('shows last message preview', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(
          find.text('Did you see the new Flutter docs?'), findsOneWidget);
      expect(find.text('The PR is ready for review.'), findsOneWidget);
      expect(find.text('Thanks for the feedback!'), findsOneWidget);
    });

    testWidgets('tapping a conversation navigates to conversation screen',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      // Tap the first conversation
      await tester.tap(find.text('Alice Chen'));
      await tester.pumpAndSettle();

      expect(find.text('Conversation c1'), findsOneWidget);
    });

    testWidgets('contains a ListView', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
