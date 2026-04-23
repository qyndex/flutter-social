import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social/widgets/scaffold_with_nav.dart';

Widget _buildTestWidget({String initialLocation = '/feed'}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/feed',
            builder: (_, __) => const Center(child: Text('Feed Page')),
          ),
          GoRoute(
            path: '/messages',
            builder: (_, __) => const Center(child: Text('Messages Page')),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const Center(child: Text('Profile Page')),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('ScaffoldWithNav', () {
    testWidgets('shows bottom navigation bar with 3 destinations',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(3));
    });

    testWidgets('shows Feed, Messages, Profile labels', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('displays Feed page content at /feed', (tester) async {
      await tester.pumpWidget(_buildTestWidget(initialLocation: '/feed'));
      await tester.pumpAndSettle();

      expect(find.text('Feed Page'), findsOneWidget);
    });

    testWidgets('navigates to Messages when Messages tab is tapped',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Messages'));
      await tester.pumpAndSettle();

      expect(find.text('Messages Page'), findsOneWidget);
    });

    testWidgets('navigates to Profile when Profile tab is tapped',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Page'), findsOneWidget);
    });

    testWidgets('navigates back to Feed from another tab', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      // Go to Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Profile Page'), findsOneWidget);

      // Back to Feed
      await tester.tap(find.text('Feed'));
      await tester.pumpAndSettle();
      expect(find.text('Feed Page'), findsOneWidget);
    });

    testWidgets('shows home icon for Feed destination', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      // The selected icon (home) and unselected (home_outlined) both exist
      // but only one is actively rendered based on selection
      expect(
        find.byIcon(Icons.home).evaluate().isNotEmpty ||
            find.byIcon(Icons.home_outlined).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('shows person icon for Profile destination', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.person).evaluate().isNotEmpty ||
            find.byIcon(Icons.person_outline).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
}
