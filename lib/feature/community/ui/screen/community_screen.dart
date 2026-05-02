import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/community/logic/controller/community_controller.dart';
import 'package:egytravel_app/feature/community/ui/widgets/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D1B2E),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// Custom Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(CupertinoIcons.back, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Community Feed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    Obx(() => controller.isLoading.value 
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : IconButton(
                          onPressed: () => controller.fetchFeed(),
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                        ),
                    ),
                  ],
                ),
              ),

              /// Feed
              Expanded(
                child: Obx(() {
                  if (controller.hasError.value && controller.posts.isEmpty) {
                    return _buildErrorState(controller);
                  }

                  if (controller.posts.isEmpty && !controller.isLoading.value) {
                    return _buildEmptyState();
                  }

                  return Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: RefreshIndicator(
                      onRefresh: () => controller.fetchFeed(),
                      color: AppColor.primary,
                      backgroundColor: const Color(0xFF1A1A1A),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.isLoading.value ? 5 : controller.posts.length,
                        itemBuilder: (context, index) {
                          if (controller.isLoading.value) {
                            return _buildSkeletonCard();
                          }
                          final post = controller.posts[index];
                          return PostCard(post: post);
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostDialog(context, controller),
        backgroundColor: AppColor.primary,
        child: const Icon(CupertinoIcons.add, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.square_stack_3d_up, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('No posts found', style: TextStyle(color: Colors.white54, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildErrorState(CommunityController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(controller.errorMessage.value, 
              style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.fetchFeed(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showAddPostDialog(BuildContext context, CommunityController controller) {
    final textController = TextEditingController();
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Create New Post', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) setModalState(() => pickedImage = image);
                  },
                  child: Container(
                    width: double.infinity, height: 200,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
                    child: pickedImage != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(pickedImage!.path), fit: BoxFit.cover))
                        : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(CupertinoIcons.camera_fill, color: AppColor.primary, size: 40), SizedBox(height: 12), Text('Tap to select an image', style: TextStyle(color: Colors.white54))]),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(hintText: "Add a caption...", hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 20),
                Obx(() => SizedBox(
                  width: double.infinity, height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () {
                      controller.createPost(
                        description: textController.text,
                        mediaUrl: pickedImage?.path, // Use local path
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: controller.isLoading.value 
                      ? const CupertinoActivityIndicator(color: Colors.black)
                      : const Text('Post Now', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
