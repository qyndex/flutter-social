/// Data models for the social app.
///
/// Each model has a [fromJson] factory for Supabase row deserialization
/// and a [toJson] method for inserts/updates.

class AppProfile {
  final String id;
  final String username;
  final String fullName;
  final String bio;
  final String avatarUrl;
  final DateTime createdAt;

  // Computed counts (filled by queries with aggregates)
  final int followerCount;
  final int followingCount;
  final int postCount;

  const AppProfile({
    required this.id,
    required this.username,
    this.fullName = '',
    this.bio = '',
    this.avatarUrl = '',
    required this.createdAt,
    this.followerCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
  });

  factory AppProfile.fromJson(Map<String, dynamic> json) {
    return AppProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: (json['full_name'] as String?) ?? '',
      bio: (json['bio'] as String?) ?? '',
      avatarUrl: (json['avatar_url'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      followerCount: (json['follower_count'] as int?) ?? 0,
      followingCount: (json['following_count'] as int?) ?? 0,
      postCount: (json['post_count'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'full_name': fullName,
        'bio': bio,
        'avatar_url': avatarUrl,
      };
}

class Post {
  final String id;
  final String authorId;
  final AppProfile? author;
  final String content;
  final String? imageUrl;
  final int likesCount;
  final DateTime createdAt;

  // Client-side state
  final bool isLiked;
  final int commentCount;

  const Post({
    required this.id,
    required this.authorId,
    this.author,
    required this.content,
    this.imageUrl,
    this.likesCount = 0,
    required this.createdAt,
    this.isLiked = false,
    this.commentCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json, {bool isLiked = false, int commentCount = 0}) {
    final authorData = json['profiles'];
    return Post(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      author: authorData != null ? AppProfile.fromJson(authorData as Map<String, dynamic>) : null,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      likesCount: (json['likes_count'] as int?) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      isLiked: isLiked,
      commentCount: commentCount,
    );
  }

  Post copyWith({
    bool? isLiked,
    int? likesCount,
    int? commentCount,
  }) {
    return Post(
      id: id,
      authorId: authorId,
      author: author,
      content: content,
      imageUrl: imageUrl,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt,
      isLiked: isLiked ?? this.isLiked,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final AppProfile? author;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    this.author,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final authorData = json['profiles'];
    return Comment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      author: authorData != null ? AppProfile.fromJson(authorData as Map<String, dynamic>) : null,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.isRead,
  });
}

class Conversation {
  final String id;
  final AppProfile participant;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.participant,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });
}
