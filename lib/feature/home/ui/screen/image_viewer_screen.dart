import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/image_viewer/viewer_app_bar.dart';
import '../widgets/image_viewer/viewer_bottom_bar.dart';
import '../widgets/image_viewer/image_info_dialog.dart';

class ImageViewerScreen extends StatelessWidget {
  final dynamic imageSource;
  final int index;

  const ImageViewerScreen({
    super.key,
    required this.imageSource,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // For demo purposes, we'll assume a total count.
    // In a real app, you might pass the list of images or the total count.
    const int totalCount = 9;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image Viewer with zoom
          Center(
            child: Hero(
              tag: 'photo_$index', // Matching the tag from PhotosTab
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: imageSource is File
                    ? Image.file(imageSource, fit: BoxFit.contain)
                    : Image.network(
                        imageSource,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 48,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),

          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ViewerAppBar(currentIndex: index, totalCount: totalCount),
          ),

          // Bottom actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ViewerBottomBar(onInfoTap: () => _showImageInfo(context)),
          ),
        ],
      ),
    );
  }

  void _showImageInfo(BuildContext context) {
    Get.bottomSheet(
      ImageInfoDialog(imageSource: imageSource, index: index),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
