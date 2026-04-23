// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedHash() => r'generated';

/// See also [Feed].
@ProviderFor(Feed)
final feedProvider = AutoDisposeNotifierProvider<Feed, List<Post>>.internal(
  Feed.new,
  name: r'feedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$feedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Feed = AutoDisposeNotifier<List<Post>>;

String _$conversationsHash() => r'generated';

/// See also [conversations].
@ProviderFor(conversations)
final conversationsProvider =
    AutoDisposeProvider<List<Conversation>>.internal(
  conversations,
  name: r'conversationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);
