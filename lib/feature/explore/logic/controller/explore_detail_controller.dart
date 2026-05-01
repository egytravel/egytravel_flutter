import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:egytravel_app/core/routes/app_routes.dart';

class ExploreDetailController extends GetxController {
  final ExploreItemModel item;
  ExploreDetailController(this.item);

  final selectedTab = 0.obs;
  final ImagePicker _picker = ImagePicker();

  final photoUrls = <dynamic>[].obs;
  final reviews = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    photoUrls.assignAll([
      item.image,
      item.image,
      item.image,
    ]);
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void toggleFavorite() {
    item.isFavorite.value = !item.isFavorite.value;
  }

  void openMap() {
    Get.toNamed(Routes.mapView, arguments: item);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        photoUrls.insert(0, image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void showImageSourceDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1E2A3A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Photo',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showImageViewer(BuildContext context, dynamic source, int index) {
    // Show image in full screen dialog
    Get.dialog(
      GestureDetector(
        onTap: () => Get.back(),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: source.toString().startsWith('http')
                ? Image.network(source)
                : Image.file(
                    File(source),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 64,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
