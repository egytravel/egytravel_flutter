import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreHorizontalList extends StatelessWidget {
  final List<ExploreItemModel> items;
  final String? emptyMessage;
  final String? listId;

  const ExploreHorizontalList({
    super.key,
    required this.items,
    this.emptyMessage,
    this.listId,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: Text(
          emptyMessage ?? "No items available",
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 4, bottom: 10),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final String heroTag = '${listId ?? 'list'}_${item.id}';
          return ExploreCard(
            item: item,
            heroTag: heroTag,
            onTap: () {
              Get.toNamed(Routes.exploreDetails, arguments: {
                'item': item,
                'heroTag': heroTag,
              });
            },
          );
        },
      ),
    );
  }
}
