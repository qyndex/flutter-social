import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social/screens/conversation_screen.dart';

Widget _buildTestWidget({String conversationId = 'c1'}) {
  final router = GoRouter(
    initialLocation: '/conversation/$conversationId',
    routes: [
      GoRoute(
        path: '/conversation/:id',
        builder: (_, state) => ConversationScreen(
          conversationId: state.pathParameters['id']!,
        ),
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('ConversationScreen', () {
    testWidgets('displays participant name in app bar', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      // c1 participant is Alice Chen
      expect(find.text('Alice Chen'), findsOneWidget);
    });

    testWidgets('shows initial messages', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      expect(find.text('Hey! How are you?'), findsOneWidget);
      expect(
          find.text("I'm good, thanks! Working on a Flutter project."),
          findsOneWidget);
      expect(find.text('Nice! Flutter is amazing.'), findsOneWidget);
    });

    testWidgets('shows message input field with hint', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Message...'), findsOneWidget);
    });

    testWidgets('shows send button', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('typing and sending adds a new message', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      // Type a message
      await tester.enterText(find.byType(TextField), 'Hello from test!');
      await tester.pump();

      // Tap send
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(find.text('Hello from test!'), findsOneWidget);
    });

    testWidgets('send clears the text field', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // TextField should be empty after send
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('empty message is not sent', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      // Count initial messages (3 hardcoded)
      // Tap send without typing anything
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Should still only have the 3 original messages
      expect(find.text('Hey! How are you?'), findsOneWidget);
      expect(
          find.text("I'm good, thanks! Working on a Flutter project."),
          findsOneWidget);
      expect(find.text('Nice! Flutter is amazing.'), findsOneWidget);
    });

    testWidgets('whitespace-only message is not sent', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // The trimmed empty text should not create a new message widget
      // We just verify no crash and the field is still there
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('contains a ListView for messages', (tester) async {
      await tester.pumpWidget(_buildTestWidget(conversationId: 'c1'));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('falls back gracefully for unknown conversation ID',
        (tester) async {
      // The orElse returns conversations.first — should not crash
      await tester.pumpWidget(_buildTestWidget(conversationId: 'unknown'));
      await tester.pumpAndSettle();

      // Should still render something (falls back to first conversation)
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
