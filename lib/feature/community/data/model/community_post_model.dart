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
      final firstImage = (json['images'] as List).first;
      imageUrl = firstImage is String ? firstImage : firstImage?.toString();
    } else {
      imageUrl = json['media_url']?.toString();
    }

    // Handle author or user object
    final authorData = json['author'] ?? json['user'] ?? {};

    // Safely extract location - may be a String or a Map object
    String? locationStr;
    final rawLocation = json['location'] ?? json['place'];
    if (rawLocation is String) {
      locationStr = rawLocation;
    } else if (rawLocation is Map) {
      locationStr = rawLocation['name']?.toString() ?? rawLocation['city']?.toString();
    }

    // Try every possible API field name for "liked by current user"
    bool resolvedIsLiked = false;
    for (final key in ['liked', 'isLiked', 'is_liked', 'userLiked', 'hasLiked', 'user_liked', 'has_liked', 'likedByMe']) {
      final val = json[key];
      if (val != null) {
        resolvedIsLiked = val == true || val == 1 || val == 'true';
        break;
      }
    }

    return CommunityPost(
      id: postId.toString(),
      description: caption,
      mediaUrl: imageUrl,
      location: locationStr,
      likesCount: (json['likesCount'] ?? json['likes_count'] ?? 0) as int,
      commentsCount: (json['commentsCount'] ?? json['comments_count'] ?? 0) as int,
      isLiked: resolvedIsLiked,
      createdAt: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      user: PostUser.fromJson(authorData is Map<String, dynamic> ? authorData : {}),
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
      createdAt: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      user: PostUser.fromJson(
        (json['author'] ?? json['user']) is Map<String, dynamic>
            ? json['author'] ?? json['user']
            : {},
      ),
    );
  }
}
