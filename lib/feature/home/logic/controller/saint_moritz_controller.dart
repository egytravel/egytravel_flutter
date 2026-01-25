import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/model/review_model.dart';
import '../../ui/screen/image_viewer_screen.dart';

class SaintMoritzController extends GetxController {
  var selectedTab = 0.obs;
  var isFavorite = false.obs;
  final ImagePicker _picker = ImagePicker();

  var photoUrls = <dynamic>[
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'https://images.unsplash.com/photo-1605540436563-5bca919ae766?w=400',
    'https://images.unsplash.com/photo-1551524164-687a55dd1126?w=400',
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400',
    'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=400',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'https://images.unsplash.com/photo-1605540436563-5bca919ae766?w=400',
    'https://images.unsplash.com/photo-1551524164-687a55dd1126?w=400',
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400',
  ].obs;

  var reviews = <Review>[
    Review(
      name: 'Shane Watson',
      avatar: 'https://i.pravatar.cc/150?img=33',
      rating: 5.0,
      date: '1 day ago',
      comment:
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
    Review(
      name: 'Destiny Wilson',
      avatar: 'https://i.pravatar.cc/150?img=45',
      rating: 5.0,
      date: '15 days ago',
      comment:
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
  ].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      photoUrls.add(File(image.path));
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      photoUrls.add(File(image.path));
    }
  }

  void addReview(Review review) {
    reviews.insert(0, review);
  }

  void showImageSourceDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF6C5CE7),
                ),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: Color(0xFF6C5CE7)),
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void showImageViewer(BuildContext context, dynamic imageSource, int index) {
    Get.to(
      () => ImageViewerScreen(imageSource: imageSource, index: index),
      transition: Transition.fadeIn,
    );
  }
}
