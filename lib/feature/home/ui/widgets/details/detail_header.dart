import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../logic/controller/place_detail_controller.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glass_action_button.dart';

class DetailHeader extends StatelessWidget {
  final PlaceDetailController controller;

  const DetailHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main image with Hero animation
        Hero(
          tag: 'place_image_${controller.place.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: CachedNetworkImage(
              height: 320,
              width: double.infinity,
              imageUrl: controller.place.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[800]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
              ),
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 320,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.2),
              ],
            ),
          ),
        ),
        // Top bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Row(
                  children: [
                    Obx(
                      () => GlassActionButton(
                        icon: controller.isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: controller.isFavorite.value
                            ? Colors.red
                            : Colors.white,
                        onTap: controller.toggleFavorite,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GlassActionButton(icon: Icons.share, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}

