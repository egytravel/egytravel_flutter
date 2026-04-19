class CommunityPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String postImage;
  final String description;
  final String location;
  int likesCount;
  bool isLiked;
  final List<String> comments;

  CommunityPost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.postImage,
    required this.description,
    this.location = '',
    this.likesCount = 0,
    this.isLiked = false,
    this.comments = const [],
  });

  CommunityPost copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    String? postImage,
    String? description,
    String? location,
    int? likesCount,
    bool? isLiked,
    List<String>? comments,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      postImage: postImage ?? this.postImage,
      description: description ?? this.description,
      location: location ?? this.location,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
    );
  }
}
