import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreCard extends StatelessWidget {
  final ExploreItemModel item;
  final VoidCallback? onTap;

  const ExploreCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              _buildImage(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0A1628).withOpacity(0.4),
                      const Color(0xFF0A1628).withOpacity(0.9),
                    ],
                    stops: const [0.4, 0.7, 1.0],
                  ),
                ),
              ),

              // Rating Badge (Top Left)
              if (item.type != ExploreItemType.flight)
                Positioned(
                  top: 10,
                  left: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Favorite Button (Top Right)
              Positioned(
                top: 10,
                right: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          item.isFavorite.value = !item.isFavorite.value;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            item.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: item.isFavorite.value
                                ? Colors.red
                                : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Info Container (Bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Location / Flight Dates
                          Row(
                            children: [
                              if (item.type != ExploreItemType.flight)
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                              if (item.type == ExploreItemType.flight)
                                const Icon(
                                  Icons.date_range_rounded,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.type == ExploreItemType.flight
                                      ? (item.date ?? '')
                                      : item.location,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Title
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Price / Type Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  item.price,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00BFA6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.type == ExploreItemType.restaurant &&
                                  item.cuisine != null) ...[
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.orange.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      item.cuisine!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Optimizes Unsplash image URL for faster loading.
  String _optimizeImageUrl(String url) {
    if (url.contains('unsplash.com')) {
      // Remove existing params and use smaller, compressed version
      final baseUrl = url.split('?').first;
      return '$baseUrl?w=400&q=75&fm=webp';
    }
    return url;
  }

  /// Builds the appropriate image widget.
  Widget _buildImage() {
    // Handle empty or missing image (e.g. flights)
    if (item.image.isEmpty) {
      return Container(
        color: const Color(0xFF1A2A44),
        child: Center(
          child: Icon(
            _getPlaceholderIcon(),
            color: Colors.white24,
            size: 48,
          ),
        ),
      );
    }

    if (item.image.startsWith('http')) {
      final optimizedUrl = _optimizeImageUrl(item.image);
      return CachedNetworkImage(
        imageUrl: optimizedUrl,
        fit: BoxFit.cover,
        memCacheWidth: 400,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => Container(
          color: const Color(0xFF1A2A44),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF1A2A44),
          child: Center(
            child: Icon(
              _getPlaceholderIcon(),
              color: Colors.white24,
              size: 48,
            ),
          ),
        ),
      );
    }

    // Fallback for local assets
    return Image.asset(
      item.image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF1A2A44),
        child: const Icon(Icons.image, color: Colors.white24, size: 48),
      ),
    );
  }

  IconData _getPlaceholderIcon() {
    switch (item.type) {
      case ExploreItemType.flight:
        return Icons.flight;
      case ExploreItemType.hotel:
        return Icons.hotel;
      case ExploreItemType.restaurant:
        return Icons.restaurant;
      case ExploreItemType.place:
        return Icons.place;
    }
  }
}
