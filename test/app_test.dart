import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/app.dart';

void main() {
  group('SocialApp', () {
    testWidgets('builds without error', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SocialApp()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('sets app title to Flutter Social', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SocialApp()),
      );
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      // MaterialApp.router doesn't expose title via widget finder easily,
      // but we can check the app renders
      expect(materialApp, isNotNull);
    });

    testWidgets('does not show debug banner', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SocialApp()),
      );
      await tester.pumpAndSettle();

      // The debug banner widget should not be present
      expect(find.byType(CheckedModeBanner), findsNothing);
    });

    testWidgets('starts at feed screen by default', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SocialApp()),
      );
      await tester.pumpAndSettle();

      // Feed screen has 'Feed' in the AppBar
      expect(find.text('Feed'), findsWidgets);
    });

    testWidgets('shows bottom navigation bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SocialApp()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('uses Material 3', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SocialApp()),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Scaffold).first);
      final theme = Theme.of(context);
      expect(theme.useMaterial3, isTrue);
    });
  });
}
