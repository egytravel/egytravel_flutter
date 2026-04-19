import 'package:egytravel_app/feature/community/data/model/community_post_model.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  final posts = <CommunityPost>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockPosts();
  }

  void loadMockPosts() {
    isLoading.value = true;
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      posts.assignAll([
        CommunityPost(
          id: '1',
          userName: 'Ahmed Ali',
          userAvatar: 'https://i.pravatar.cc/150?u=ahmed',
          postImage: 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?q=80&w=1000',
          description: 'Exploring the Great Pyramids today! Truly a magnificent sight.',
          location: 'Giza, Egypt',
          likesCount: 1250,
          isLiked: true,
          comments: ['Beautiful!', 'I want to go there!'],
        ),
        CommunityPost(
          id: '2',
          userName: 'Sarah Wilson',
          userAvatar: 'https://i.pravatar.cc/150?u=sarah',
          postImage: 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?q=80&w=1000',
          description: 'The sunset at Dahab is unlike anything else. #Egypt #Travel',
          location: 'Dahab, South Sinai',
          likesCount: 840,
          isLiked: false,
          comments: ['Pure magic'],
        ),
        CommunityPost(
          id: '3',
          userName: 'Omar Hassan',
          userAvatar: 'https://i.pravatar.cc/150?u=omar',
          postImage: 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?q=80&w=1000',
          description: 'A beautiful walk through Islamic Cairo. History everywhere.',
          location: 'Cairo, Egypt',
          likesCount: 450,
          isLiked: false,
          comments: [],
        ),
      ]);
      isLoading.value = false;
    });
  }

  void toggleLike(String postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = posts[index];
      posts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
    }
  }

  void addPost({
    required String userName,
    required String description,
    String? postImage,
  }) {
    final newPost = CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      userAvatar: 'https://i.pravatar.cc/150?u=$userName',
      postImage: postImage ?? 'https://images.unsplash.com/photo-1541167760496-162955ed8521?q=80&w=1000',
      description: description,
      location: '',
      likesCount: 0,
      isLiked: false,
      comments: [],
    );
    posts.insert(0, newPost);
  }

  void addComment(String postId, String comment) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = posts[index];
      final newComments = List<String>.from(post.comments)..add(comment);
      posts[index] = post.copyWith(comments: newComments);
    }
  }
}
