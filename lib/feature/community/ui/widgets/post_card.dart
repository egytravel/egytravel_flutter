import 'dart:ui';
import 'dart:io';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/community/data/model/community_post_model.dart';
import 'package:egytravel_app/feature/community/logic/controller/community_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatelessWidget {
  final CommunityPost post;
  final CommunityController controller = Get.find();

  PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header: User Info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white10,
                        backgroundImage: post.user.profilePhotoUrl != null
                            ? CachedNetworkImageProvider(post.user.profilePhotoUrl!)
                            : null,
                        child: post.user.profilePhotoUrl == null
                            ? const Icon(Icons.person, color: Colors.white38)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (post.location != null && post.location!.isNotEmpty)
                            Text(
                              post.location!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                /// Post Image
                if (post.mediaUrl != null)
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        post.mediaUrl!.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: post.mediaUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Colors.white10,
                                  child: const Center(
                                    child: CupertinoActivityIndicator(
                                        color: Colors.white),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white10,
                                  child: const Icon(Icons.error_outline,
                                      color: Colors.white24),
                                ),
                              )
                            : Image.file(
                                File(post.mediaUrl!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                /// Actions: Like, Comment, Share
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleLike(post.id),
                        child: Row(
                          children: [
                            Icon(
                              post.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              color: post.isLiked ? Colors.redAccent : Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              post.likesCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () => _showCommentsBottomSheet(context),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.chat_bubble, color: Colors.white, size: 26),
                            if (post.commentsCount > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                post.commentsCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(CupertinoIcons.paperplane, color: Colors.white, size: 26),
                      const SizedBox(width: 12,)
                    ],
                  ),
                ),

                /// Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${post.user.name} ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: post.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Comments',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Loading comments...', style: TextStyle(color: Colors.white38)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: const TextStyle(color: Colors.white38),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        controller.addComment(post.id, commentController.text);
                        commentController.clear();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(CupertinoIcons.arrow_up_circle_fill, color: AppColor.primary, size: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
