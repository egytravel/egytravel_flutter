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
  Future<List<CommunityComment>> getPostComments(String id) async {
    final response = await _api.get(EndPoint.communityPostComments(id));
    
    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .map((c) => CommunityComment.fromJson(c))
          .toList();
    }
    return [];
  }

  // ── ADD Comment ──────────────────────────────────────────────────────────
  Future<CommunityComment> addComment(String postId, String content) async {
    final response = await _api.post(EndPoint.communityPostComments(postId), data: {
      'comment': content,
    });
    final data = _extractData(response);
    return CommunityComment.fromJson(data['comment'] ?? data);
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
