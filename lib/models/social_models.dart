class User {
  final String id;
  final String username;
  final String displayName;
  final String bio;
  final String avatarUrl;
  final int followerCount;
  final int followingCount;
  final int postCount;
  final bool isFollowing;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.avatarUrl,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    required this.isFollowing,
  });
}

class Post {
  final String id;
  final User author;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool isLiked;

  const Post({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
  });
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
  final User participant;
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
