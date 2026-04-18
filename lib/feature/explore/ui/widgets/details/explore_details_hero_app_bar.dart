import 'package:cached_network_image/cached_network_image.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreDetailsHeroAppBar extends StatelessWidget {
  final ExploreItemModel item;

  const ExploreDetailsHeroAppBar({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: const BackButton(color: Colors.black),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Obx(
            () => IconButton(
              icon: Icon(
                item.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite.value ? Colors.red : Colors.black,
              ),
              onPressed: () => controller.toggleFavorite(item),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: item.title,
          child: _buildHeroImage(),
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
