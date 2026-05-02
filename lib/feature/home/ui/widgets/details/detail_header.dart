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
    return SliverAppBar(
      expandedHeight: 320.0,
      collapsedHeight: 150.0,
      pinned: true,
      backgroundColor:
          Colors.transparent, // Transparent to prevent hiding the image
      elevation: 0,
      automaticallyImplyLeading: false, // Custom leading
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Hero(
            tag: 'place_image_${controller.place.id}',
            child: Container(
              decoration: const BoxDecoration(
                color: Color(
                  0xFF0A1628,
                ), // Dark background behind image to prevent text bleed
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: SizedBox(
                  height: constraints.maxHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: controller.place.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[800]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      titleSpacing: 16,
      title: Row(
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
            ],
          ),
        ],
      ),
    );
  }
}
