import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/community/data/model/community_post_model.dart';

class CommunityRepo {
  final ApiService _api = ApiService();

  // ── GET Feed ─────────────────────────────────────────────────────────────
  Future<List<CommunityPost>> getFeed({int page = 1, int limit = 10}) async {
    final response = await _api.get('${EndPoint.communityFeed}?page=$page&limit=$limit');
    
    // The API returns { "success": true, "data": [...] }
    List data = [];
    if (response is List) {
      data = response;
    } else if (response is Map<String, dynamic> && response['data'] is List) {
      data = response['data'];
    }

    return data.map((p) => CommunityPost.fromJson(p)).toList();
  }

  // ── CREATE Post ──────────────────────────────────────────────────────────
  Future<CommunityPost> createPost({
    required String description,
    String? mediaUrl,
    String? location,
  }) async {
    final response = await _api.post(EndPoint.communityPosts, data: {
      'caption': description,
      if (mediaUrl != null) 'images': [mediaUrl],
      if (location != null) 'location': location,
    });
    
    final data = _extractData(response);
    return CommunityPost.fromJson(data['post'] ?? data);
  }

  // ── GET Single Post ──────────────────────────────────────────────────────
  Future<CommunityPost> getPostDetails(String id) async {
    final response = await _api.get(EndPoint.communityPostById(id));
    final data = _extractData(response);
    return CommunityPost.fromJson(data['post'] ?? data);
  }

  // ── DELETE Post ──────────────────────────────────────────────────────────
  Future<void> deletePost(String id) async {
    await _api.delete(EndPoint.communityPostById(id));
  }

  // ── TOGGLE Like ──────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> toggleLike(String id) async {
    final response = await _api.post(EndPoint.communityPostLikes(id), data: {});
    return _extractData(response);
  }

  // ── GET Comments ─────────────────────────────────────────────────────────
  // Tries the dedicated /comments endpoint first, then falls back to post details
  Future<List<CommunityComment>> getPostComments(String id) async {
    try {
      // 1. Try the dedicated comments endpoint first (usually returns ALL comments)
      final commentsResponse = await _api.get(EndPoint.communityPostComments(id));
      if (commentsResponse is Map<String, dynamic> && commentsResponse['data'] is List) {
        return (commentsResponse['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((c) => CommunityComment.fromJson(c))
            .toList();
      } else if (commentsResponse is List) {
        return commentsResponse
            .whereType<Map<String, dynamic>>()
            .map((c) => CommunityComment.fromJson(c))
            .toList();
      }
    } catch (e) {
      print('DEBUG: Dedicated comments endpoint failed, falling back: $e');
    }

    // 2. Fallback to post details (your debug log confirmed this works but might be limited to 3 recent ones)
    final response = await _api.get(EndPoint.communityPostById(id));
    print('DEBUG: Fallback Comments response for post $id: $response');

    List rawComments = [];
    if (response is Map<String, dynamic>) {
      final inner = response['data'] ?? response;
      if (inner is Map<String, dynamic>) {
        // Try every possible key for comments list
        rawComments = inner['recentComments'] ?? 
                      inner['comments'] ?? 
                      (inner['post'] is Map ? (inner['post']['recentComments'] ?? inner['post']['comments']) : null) ?? 
                      [];
      }
    }

    return rawComments
        .whereType<Map<String, dynamic>>()
        .map((c) => CommunityComment.fromJson(c))
        .toList();
  }

  // ── ADD Comment ──────────────────────────────────────────────────────────
  Future<CommunityComment> addComment(String postId, String content) async {
    final response = await _api.post(EndPoint.communityPostComments(postId), data: {
      'comment': content,
    });
    final data = _extractData(response);
    return CommunityComment.fromJson(data['comment'] ?? data);
  }

  // ── DELETE Comment ───────────────────────────────────────────────────────
  Future<void> deleteComment(String commentId) async {
    await _api.delete(EndPoint.communityCommentById(commentId));
  }

  // ── GET User Posts ────────────────────────────────────────────────────────
  Future<List<CommunityPost>> getUserPosts(String userId) async {
    final response = await _api.get(EndPoint.communityUserPosts(userId));
    List data = [];
    if (response is Map<String, dynamic> && response['data'] is List) {
      data = response['data'];
    } else if (response is List) {
      data = response;
    }
    return data.map((p) => CommunityPost.fromJson(p as Map<String, dynamic>)).toList();
  }

  // ── GET Feed for Specific Place ───────────────────────────────────────────
  Future<List<CommunityPost>> getFeedForPlace(String placeId) async {
    final response = await _api.get('${EndPoint.communityFeed}?place=$placeId');
    List data = [];
    if (response is Map<String, dynamic> && response['data'] is List) {
      data = response['data'];
    }
    return data.map((p) => CommunityPost.fromJson(p as Map<String, dynamic>)).toList();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Map<String, dynamic> _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        final data = response['data'];
        if (data is Map<String, dynamic>) return data;
        // If data is a list, we shouldn't cast it to Map
      }
      return response;
    }
    return {};
  }
}
