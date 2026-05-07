import 'package:egytravel_app/feature/community/data/model/community_post_model.dart';
import 'package:egytravel_app/feature/community/data/repo/community_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityController extends GetxController {
  final CommunityRepo _repo = CommunityRepo();

  final posts = <CommunityPost>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Store comments per post ID
  final postComments = <String, List<CommunityComment>>{}.obs;
  final isCommentsLoading = <String, bool>{}.obs;

  // Local cache of liked post IDs — persists across reloads
  static const _likedPostsKey = 'liked_post_ids';
  final Set<String> _likedPostIds = {};

  @override
  void onInit() {
    super.onInit();
    _loadLikedPostIds().then((_) => fetchFeed());
  }

  // ── LOCAL LIKE CACHE ─────────────────────────────────────────────────────

  Future<void> _loadLikedPostIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_likedPostsKey) ?? [];
    _likedPostIds.addAll(stored);
  }

  Future<void> _saveLikedPostIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedPostsKey, _likedPostIds.toList());
  }

  bool isPostLiked(String postId) => _likedPostIds.contains(postId);

  // ── FETCH Feed ───────────────────────────────────────────────────────────
  Future<void> fetchFeed() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final result = await _repo.getFeed();

      // Apply local liked state on top of server state
      final merged = result.map((post) {
        // Prefer local cache — it reflects user's actual taps
        final locallyLiked = _likedPostIds.contains(post.id);
        // Also trust server if it explicitly says liked
        final serverLiked = post.isLiked;
        final finalLiked = locallyLiked || serverLiked;

        // Sync cache with server truth
        if (serverLiked) _likedPostIds.add(post.id);

        return post.copyWith(isLiked: finalLiked);
      }).toList();

      await _saveLikedPostIds();
      posts.assignAll(merged);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ── TOGGLE Like ──────────────────────────────────────────────────────────
  Future<void> toggleLike(String postId) async {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final originalPost = posts[index];
    final newLikedState = !originalPost.isLiked;

    // 1. Update local cache immediately
    if (newLikedState) {
      _likedPostIds.add(postId);
    } else {
      _likedPostIds.remove(postId);
    }
    await _saveLikedPostIds();

    // 2. Optimistic UI update
    posts[index] = originalPost.copyWith(
      isLiked: newLikedState,
      likesCount: newLikedState
          ? originalPost.likesCount + 1
          : originalPost.likesCount - 1,
    );
    posts.refresh();

    try {
      // 3. Send to server with auth token (handled by ApiService)
      final result = await _repo.toggleLike(postId);

      // 4. Sync count from server if available
      final serverCount = result['likesCount'] ??
          result['likes_count'] ??
          result['count'] ??
          posts[index].likesCount;

      // 5. Use server count but KEEP local liked state (most reliable)
      posts[index] = posts[index].copyWith(
        isLiked: newLikedState, // trust local tap, not server field
        likesCount: serverCount is int ? serverCount : posts[index].likesCount,
      );
      posts.refresh();
    } catch (e) {
      // 6. Revert everything on failure
      if (newLikedState) {
        _likedPostIds.remove(postId);
      } else {
        _likedPostIds.add(postId);
      }
      await _saveLikedPostIds();
      posts[index] = originalPost;
      posts.refresh();
      Get.snackbar('Error', 'Failed to update like. Check connection.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // ── CREATE Post ──────────────────────────────────────────────────────────
  Future<void> createPost({
    required String description,
    String? mediaUrl,
    String? location,
  }) async {
    try {
      isLoading.value = true;
      final newPost = await _repo.createPost(
        description: description,
        mediaUrl: mediaUrl,
        location: location,
      );
      posts.insert(0, newPost);
      Get.back();
      Get.snackbar('Success', 'Post created successfully',
          backgroundColor: const Color(0xFF10B981), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post');
    } finally {
      isLoading.value = false;
    }
  }

  // ── FETCH Comments ───────────────────────────────────────────────────────
  Future<void> fetchComments(String postId) async {
    try {
      isCommentsLoading[postId] = true;
      isCommentsLoading.refresh();
      final result = await _repo.getPostComments(postId);
      postComments[postId] = result;
      postComments.refresh();
      update(); // Manual update for GetBuilder
    } catch (e) {
      Get.snackbar('Error', 'Failed to load comments');
    } finally {
      isCommentsLoading[postId] = false;
      isCommentsLoading.refresh();
      update();
    }
  }

  // ── ADD Comment ──────────────────────────────────────────────────────────
  Future<void> addComment(String postId, String content) async {
    if (content.trim().isEmpty) return;

    // 1. Create a temporary local comment for instant UI feedback (Optimistic)
    final tempComment = CommunityComment(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      createdAt: DateTime.now(),
      user: PostUser(id: 'me', name: 'you'), // Placeholder user
    );

    // 2. Add it to the local list immediately
    final existingComments = postComments[postId] ?? [];
    postComments[postId] = [tempComment, ...existingComments];
    postComments.refresh(); 
    update(); // Force GetBuilder update

    try {
      // 3. Sync with server
      await _repo.addComment(postId, content);
      
      // 4. Update the "true" count in the post list
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index] = posts[index].copyWith(
          commentsCount: posts[index].commentsCount + 1,
        );
        posts.refresh();
      }

      // 5. Refetch the official list from server to replace the temp comment
      await fetchComments(postId);
      
      Get.snackbar('Success', 'Comment added',
          backgroundColor: const Color(0xFF10B981), colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      // Revert on error
      await fetchComments(postId);
      Get.snackbar('Error', 'Failed to add comment. Please try again.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // ── DELETE Post ──────────────────────────────────────────────────────────
  Future<void> deletePost(String postId) async {
    try {
      await _repo.deletePost(postId);
      posts.removeWhere((p) => p.id == postId);
      _likedPostIds.remove(postId);
      await _saveLikedPostIds();
      Get.snackbar('Deleted', 'Post removed successfully',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post');
    }
  }

  // ── DELETE Comment ────────────────────────────────────────────────────────
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _repo.deleteComment(commentId);
      await fetchComments(postId);
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1 && posts[index].commentsCount > 0) {
        posts[index] = posts[index].copyWith(
          commentsCount: posts[index].commentsCount - 1,
        );
        posts.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete comment');
    }
  }

  // ── GET User Posts ─────────────────────────────────────────────────────────
  Future<List<CommunityPost>> getUserPosts(String userId) async {
    try {
      return await _repo.getUserPosts(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user posts');
      return [];
    }
  }

  // ── GET Feed for Place ─────────────────────────────────────────────────────
  Future<void> fetchFeedForPlace(String placeId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final result = await _repo.getFeedForPlace(placeId);
      posts.assignAll(result);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
