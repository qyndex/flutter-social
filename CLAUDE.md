# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter Social -- a full-featured social media app with feed, user profiles, messaging, and post detail views. Built with Flutter 3.24+, Dart 3.5+, Riverpod (with code generation) for state management, and GoRouter for declarative navigation.

## Commands

```bash
# Dependencies
flutter pub get                          # Install dependencies
dart run build_runner build              # Generate Riverpod code (.g.dart files)
dart run build_runner watch              # Watch and regenerate on changes

# Run
flutter run                              # Run on connected device/emulator
flutter run -d chrome                    # Run in Chrome (web)
flutter run -d macos                     # Run on macOS desktop

# Test
flutter test                             # Run all widget tests
flutter test test/models/                # Run model tests only
flutter test test/providers/             # Run provider tests only
flutter test test/screens/               # Run screen tests only
flutter test test/widgets/               # Run widget tests only
flutter test --coverage                  # Run tests with coverage report

# Quality
flutter analyze                          # Static analysis (uses analysis_options.yaml)
dart format .                            # Format all Dart files
dart format --set-exit-if-changed .      # Format check (CI mode)

# Build
flutter build web --release              # Production web build
flutter build apk --release              # Android APK
flutter build ios --release              # iOS (macOS only)
docker build -t flutter-social .         # Dockerized web build (nginx)
```

## Architecture

```
lib/
  main.dart                  # Entry point: ProviderScope + SocialApp
  app.dart                   # MaterialApp.router, GoRouter config, theme
  models/
    social_models.dart       # Data classes: User, Post, Message, Conversation
  providers/
    feed_provider.dart       # Riverpod providers (codegen): Feed notifier, conversations, currentUser
    feed_provider.g.dart     # Generated code (run build_runner to regenerate)
  screens/
    feed_screen.dart         # Main feed with pull-to-refresh + FAB
    messages_screen.dart     # Conversation list with unread badges
    profile_screen.dart      # Current user profile with stats grid
    conversation_screen.dart # Chat UI with message input + send
    post_detail_screen.dart  # Single post view with comments
    user_profile_screen.dart # Other user's profile (placeholder)
  widgets/
    post_card.dart           # Post display: avatar, content, image, like/comment/share
    scaffold_with_nav.dart   # Shell layout with bottom NavigationBar + unread badge
  services/
    api_service.dart         # Dio HTTP client with interceptors (provider-based)
test/
  app_test.dart              # SocialApp integration tests
  models/                    # Model unit tests
  providers/                 # Provider unit tests
  screens/                   # Screen widget tests
  services/                  # Service tests
  widgets/                   # Widget tests
```

## Key Patterns

### State Management (Riverpod + Codegen)
- `@riverpod` annotation on classes generates `AutoDisposeNotifierProvider` (e.g., `feedProvider`)
- `@riverpod` annotation on functions generates `AutoDisposeProvider` (e.g., `conversationsProvider`)
- After changing providers, regenerate: `dart run build_runner build`
- Access notifiers: `ref.read(feedProvider.notifier).toggleLike(id)`
- Watch state: `ref.watch(feedProvider)` in `build()` methods

### Navigation (GoRouter)
- ShellRoute wraps tabbed screens (feed, messages, profile) with `ScaffoldWithNav`
- Detail routes (`/post/:id`, `/user/:id`, `/conversation/:id`) are outside the shell
- Navigate: `context.push('/post/$id')` for detail, `context.go('/feed')` for tab switch
- Route params accessed via `state.pathParameters['id']!`

### Widgets
- `ConsumerWidget` / `ConsumerStatefulWidget` for Riverpod integration
- Const constructors on all stateless/immutable widgets
- `PostCard` handles navigation to post detail and user profile internally

### API Layer
- `ApiService` wraps Dio with typed generic methods (`get<T>`, `post<T>`, etc.)
- Base URL and timeouts configured in `dioProvider`
- LogInterceptor enabled for debugging

## Rules

- Use `StatelessWidget` / `ConsumerWidget` unless mutable state is needed
- All providers go in `providers/` with `@riverpod` annotation; run codegen after changes
- All data classes go in `models/social_models.dart` (no JSON serialization yet -- add when connecting real API)
- Widgets must be const-constructible where possible
- Follow effective Dart style guide and analysis_options.yaml rules
- Separate business logic (providers/services) from UI (screens/widgets)
- GoRouter routes are the single source of truth for navigation
- No raw `Navigator.push` -- always use GoRouter (`context.push`, `context.go`)
- `implicit-casts: false` and `implicit-dynamic: false` are enforced -- explicit types everywhere
- Test every screen, widget, and provider; maintain >80% coverage on new code

## Environment

Copy `.env.example` to `.env` and fill in values. The app reads `API_BASE_URL` for the backend connection. Without a real backend, the app uses in-memory sample data from `feed_provider.dart`.

## Common Gotchas

1. Missing `.g.dart` files -- run `dart run build_runner build` after cloning or changing providers
2. `part 'feed_provider.g.dart'` must match the filename exactly
3. `_$Feed` is generated -- the `Feed` class extends it, not the other way around
4. `conversationsProvider` is a generated name from the `@riverpod` function `conversations`
5. `analysis_options.yaml` disables implicit casts/dynamic -- type errors are real
6. `cached_network_image` and `image_picker` are in deps but not yet used in screens (reserved for real API integration)
7. The Dockerfile builds for web only -- mobile builds use `flutter build apk/ios`
8. Profile screen filters `feed` for posts where `author.id == user.id` -- no posts appear until user creates one
