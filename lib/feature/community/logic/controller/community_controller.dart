import 'package:egytravel_app/feature/community/data/model/community_post_model.dart';
import 'package:egytravel_app/feature/community/data/repo/community_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  final CommunityRepo _repo = CommunityRepo();

  final posts = <CommunityPost>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeed();
  }

  // ── FETCH Feed ───────────────────────────────────────────────────────────
  Future<void> fetchFeed() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final result = await _repo.getFeed();
      posts.assignAll(result);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ── TOGGLE Like ──────────────────────────────────────────────────────────
  Future<void> toggleLike(int postId) async {
    // Optimistic UI update
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final originalPost = posts[index];
    posts[index] = originalPost.copyWith(
      isLiked: !originalPost.isLiked,
      likesCount: originalPost.isLiked ? originalPost.likesCount - 1 : originalPost.likesCount + 1,
    );
    posts.refresh();

    try {
      final result = await _repo.toggleLike(postId.toString());
      // Update with real data from server if available
      if (result.containsKey('liked') || result.containsKey('likesCount')) {
        posts[index] = posts[index].copyWith(
          isLiked: result['liked'] ?? posts[index].isLiked,
          likesCount: result['likesCount'] ?? posts[index].likesCount,
        );
        posts.refresh();
      }
    } catch (e) {
      // Revert on error
      posts[index] = originalPost;
      Get.snackbar('Error', 'Failed to update like');
    }
  }

  // ── CREATE Post ──────────────────────────────────────────────────────────
  Future<void> createPost({
    required String description,
    String? mediaUrl,
    String? location,
  }) async {
    try {
      isLoading.value = true; // or show a dialog loading
      final newPost = await _repo.createPost(
        description: description,
        mediaUrl: mediaUrl,
        location: location,
      );
      posts.insert(0, newPost);
      Get.back(); // Close post creation screen
      Get.snackbar('Success', 'Post created successfully', 
          backgroundColor: const Color(0xFF10B981), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post');
    } finally {
      isLoading.value = false;
    }
  }

  // ── ADD Comment ──────────────────────────────────────────────────────────
  Future<void> addComment(int postId, String content) async {
    if (content.trim().isEmpty) return;
    
    try {
      await _repo.addComment(postId.toString(), content);
      // Refresh feed or post details to show new comment
      // For now just show success
      Get.snackbar('Success', 'Comment added',
          backgroundColor: const Color(0xFF10B981), colorText: Colors.white);
      
      // Update local count
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index] = posts[index].copyWith(
          commentsCount: posts[index].commentsCount + 1,
        );
        posts.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add comment');
    }
  }
}
