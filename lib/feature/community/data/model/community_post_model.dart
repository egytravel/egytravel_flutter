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
      imageUrl = json['images'][0];
    } else {
      imageUrl = json['media_url'];
    }

    // Handle author or user object
    final authorData = json['author'] ?? json['user'] ?? {};

    return CommunityPost(
      id: postId.toString(),
      description: caption,
      mediaUrl: imageUrl,
      location: json['location'] ?? json['place'],
      likesCount: json['likesCount'] ?? json['likes_count'] ?? 0,
      commentsCount: json['commentsCount'] ?? json['comments_count'] ?? 0,
      isLiked: json['liked'] ?? json['isLiked'] ?? json['is_liked'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      user: PostUser.fromJson(authorData),
    );
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
      name: json['name'] ?? 'Unknown',
      profilePhotoUrl: json['profile_photo_url'] ?? json['avatar'],
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
      id: (json['commentId'] ?? json['comment_id'] ?? '').toString(),
      content: json['content'] ?? json['text'] ?? json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      user: PostUser.fromJson(json['author'] ?? json['user'] ?? {}),
    );
  }
}
