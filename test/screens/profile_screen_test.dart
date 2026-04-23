import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/screens/profile_screen.dart';

Widget _buildTestWidget() {
  return ProviderScope(
    child: MaterialApp(
      home: const ProfileScreen(),
    ),
  );
}

void main() {
  group('ProfileScreen', () {
    testWidgets('displays current user display name', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('You'), findsOneWidget);
    });

    testWidgets('displays current user username with @ prefix',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('@me'), findsOneWidget);
    });

    testWidgets('displays current user bio', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Flutter developer'), findsOneWidget);
    });

    testWidgets('shows Posts stat', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
    });

    testWidgets('shows Followers stat', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('142'), findsOneWidget);
    });

    testWidgets('shows Following stat', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Following'), findsOneWidget);
      expect(find.text('98'), findsOneWidget);
    });

    testWidgets('shows Edit Profile button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('shows settings icon in app bar', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('uses a CustomScrollView with SliverAppBar', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('shows "No posts yet" when user has no posts in feed',
        (tester) async {
      // The current user (id: 'me') has no posts in the default feed
      // (all posts are authored by sample users), so this text should appear.
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No posts yet'), findsOneWidget);
    });
  });
}
