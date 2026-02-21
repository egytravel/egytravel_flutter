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
          child: Image.asset(item.image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
