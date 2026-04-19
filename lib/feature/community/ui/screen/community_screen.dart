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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A1628),
              const Color(0xFF0D1B2E),
              const Color(0xFF000000),
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
                      onPressed: () {
                        // Using Navigator.pop to avoid GetX snackbar conflict
                        Navigator.of(context).pop();
                      },
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
                  ],
                ),
              ),

              /// Feed
              Expanded(
                child: Obx(() {
                  return Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: RefreshIndicator(
                      onRefresh: () async => controller.loadMockPosts(),
                      color: AppColor.primary,
                      backgroundColor: const Color(0xFF1A1A1A),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.posts.length,
                        itemBuilder: (context, index) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create New Post',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              /// Image Selection/Preview
              GestureDetector(
                onTap: () async {
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setModalState(() {
                      pickedImage = image;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(File(pickedImage!.path), fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.camera_fill, color: AppColor.primary, size: 40),
                            const SizedBox(height: 12),
                            const Text('Tap to select an image', style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: textController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Add a caption...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (pickedImage != null) {
                      controller.addPost(
                        userName: 'You',
                        description: textController.text,
                        postImage: pickedImage!.path,
                      );
                      Navigator.pop(context);
                      Get.snackbar(
                        'Success',
                        'Your post has been shared!',
                        backgroundColor: Colors.green.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please select an image first',
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Post Now', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
