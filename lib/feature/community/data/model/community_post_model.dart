class CommunityPost {
  final String id;
  final String description;
  final String? mediaUrl;
  final String? location;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;
  final PostUser user;

  CommunityPost({
    required this.id,
    required this.description,
    this.mediaUrl,
    this.location,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.createdAt,
    required this.user,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    // Handle both old and new API keys
    final postId = json['postId'] ?? json['post_id'] ?? '';
    final caption = json['caption'] ?? json['description'] ?? '';
    
    // Handle images array or single media_url
    String? imageUrl;
    if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      imageUrl = _s(json['images'][0]);
    } else {
      imageUrl = _sn(json['media_url']);
    }

    // Handle author or user object
    final authorData = json['author'] ?? json['user'] ?? {};

    return CommunityPost(
      id: _s(postId),
      description: _s(caption),
      mediaUrl: imageUrl,
      location: _sn(json['location'] ?? json['place']),
      likesCount: json['likesCount'] ?? json['likes_count'] ?? 0,
      commentsCount: json['commentsCount'] ?? json['comments_count'] ?? 0,
      isLiked: json['liked'] ?? json['isLiked'] ?? json['is_liked'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      user: PostUser.fromJson(authorData),
    );
  }

  // Helper methods for safe parsing
  static String _s(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    if (value is Map) {
      return (value['name'] ?? value['title'] ?? value['text'] ?? value.toString()).toString();
    }
    return value.toString();
  }

  static String? _sn(dynamic value) {
    if (value == null) return null;
    return _s(value);
  }

  CommunityPost copyWith({
    String? id,
    String? description,
    String? mediaUrl,
    String? location,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    DateTime? createdAt,
    PostUser? user,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      description: description ?? this.description,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      location: location ?? this.location,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }
}

class PostUser {
  final dynamic id;
  final String name;
  final String? profilePhotoUrl;

  PostUser({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
  });

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      id: json['id'] ?? json['user_id'] ?? 0,
      name: CommunityPost._s(json['name'] ?? 'Unknown'),
      profilePhotoUrl: CommunityPost._sn(json['profile_photo_url'] ?? json['avatar']),
    );
  }
}

class CommunityComment {
  final String id;
  final String content;
  final DateTime createdAt;
  final PostUser user;

  CommunityComment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    return CommunityComment(
      id: CommunityPost._s(json['commentId'] ?? json['comment_id'] ?? ''),
      content: CommunityPost._s(json['content'] ?? json['text'] ?? json['comment'] ?? ''),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      user: PostUser.fromJson(json['author'] ?? json['user'] ?? {}),
    );
  }
}
