import 'package:cached_network_image/cached_network_image.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class ExploreDetailsHeroAppBar extends StatelessWidget {
  final ExploreItemModel item;

  const ExploreDetailsHeroAppBar({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();

    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomBackButton(),
      ),
      actions: [
        _buildActionIcon(
          icon: Obx(() => Icon(
                item.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite.value ? Colors.red : Colors.white,
                size: 20,
              )),
          onTap: () => controller.toggleFavorite(item),
        ),
        _buildActionIcon(
          icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
          onTap: () {
            // Share logic
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: item.title,
              child: _buildHeroImage(),
            ),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon({required Widget icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    if (item.image.isEmpty) {
      return Container(
        color: const Color(0xFF1A2A44),
        child: const Center(
          child: Icon(Icons.image, color: Colors.white24, size: 64),
        ),
      );
    }

    if (item.image.startsWith('http')) {
      final optimizedUrl = _optimizeUrl(item.image);
      return CachedNetworkImage(
        imageUrl: optimizedUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: 600,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => Container(
          color: const Color(0xFF1A2A44),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white38,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF1A2A44),
          child: const Icon(
            Icons.broken_image,
            color: Colors.white38,
            size: 48,
          ),
        ),
      );
    }
    return Image.asset(item.image, fit: BoxFit.cover);
  }

  String _optimizeUrl(String url) {
    if (url.contains('unsplash.com')) {
      return '${url.split('?').first}?w=600&q=75&fm=webp';
    }
    return url;
  }
}
