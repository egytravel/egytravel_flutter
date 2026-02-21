import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreGrid extends StatelessWidget {
  final List<ExploreItemModel> items;

  const ExploreGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ExploreCard(
          item: items[index],
          onTap: () {
            Get.toNamed(Routes.exploreDetails, arguments: items[index]);
          },
        );
      },
    );
  }
}
