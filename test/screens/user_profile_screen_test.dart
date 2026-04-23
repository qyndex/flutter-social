import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_social/screens/user_profile_screen.dart';

void main() {
  group('UserProfileScreen', () {
    testWidgets('displays Profile app bar title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserProfileScreen(userId: 'u1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('shows user ID in body text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserProfileScreen(userId: 'u1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('User profile for u1'), findsOneWidget);
    });

    testWidgets('shows different user ID for different props', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserProfileScreen(userId: 'alice-123'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('User profile for alice-123'), findsOneWidget);
    });

    testWidgets('is a Scaffold', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserProfileScreen(userId: 'u1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
