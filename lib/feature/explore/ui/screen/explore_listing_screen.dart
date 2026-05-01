import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_controller.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/listing/explore_grid.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/listing/explore_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExploreListingScreen extends StatelessWidget {
  const ExploreListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreItemType? type = Get.arguments?['type'];
    final String? initialCategory = Get.arguments?['category'];
    final controller = Get.put(ExploreController());

    final List<ExploreItemModel> items = _getItemsByType(controller, type, initialCategory);

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _getScreenTitle(type, initialCategory),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            ExploreSearchBar(
              onFilterPressed: () {
                // Show filter dialog/bottom sheet
              },
              onChanged: (val) => controller.updateSearchQuery(val),
            ),
            Expanded(
              child: Obx(() {
                final currentItems = _getItemsByType(controller, type, initialCategory);

                if (controller.isLoading.value && currentItems.isEmpty) {
                  return Skeletonizer(
                    enabled: true,
                    child: ExploreGrid(items: controller.dummyItems),
                  );
                }

                return Skeletonizer(
                  enabled: controller.isLoading.value,
                  child: currentItems.isEmpty
                      ? const Center(
                          child: Text(
                            'No items found',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        )
                      : ExploreGrid(items: currentItems),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<ExploreItemModel> _getItemsByType(
    ExploreController controller,
    ExploreItemType? type,
    String? category,
  ) {
    return controller.getItemsForListing(type, category);
  }

  String _getScreenTitle(ExploreItemType? type, String? category) {
    String title = "Explore";
    if (type != null) {
      switch (type) {
        case ExploreItemType.place:
          title = "Places";
          break;
        case ExploreItemType.restaurant:
          title = "Restaurants";
          break;
        case ExploreItemType.hotel:
          title = "Hotels";
          break;
        case ExploreItemType.flight:
          title = "Flights";
          break;
      }
    }
    if (category != null) {
      title = "$category $title";
    }
    return title;
  }
}
