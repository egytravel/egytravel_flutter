import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_controller.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_app_bar.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_category_list.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_horizontal_list.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreScreen extends GetView<ExploreController> {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ExploreController>()) {
      Get.put(ExploreController());
    }

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ExploreAppBar(onMapPressed: controller.openMapView),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =============> Explore Places Section
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Explore Places",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Category Chips
              ExploreCategoryList(
                categories: controller.placeCategories,
                selectedCategory: controller.selectedPlaceCategory,
                onCategoryChanged: controller.changePlaceCategory,
              ),
              const SizedBox(height: 16),

              // =============> Recommended Places
              Obx(
                () => ExploreHorizontalList(
                  items: controller.placesForSelectedCategory,
                  emptyMessage: "No places found in this category",
                ),
              ),
              const SizedBox(height: 20),
              ExploreSectionHeader(
                title: "Recommended",
                onSeeAll: () => controller.navigateToSeeAll(
                  ExploreItemType.place,
                  category: 'Recommended',
                ),
              ),
              ExploreHorizontalList(items: controller.recommendedPlaces),

              // Categorized Items List
              const SizedBox(height: 24),

              // =============> Restaurants
              ExploreSectionHeader(
                title: "Top Restaurants",
                onSeeAll: () =>
                    controller.navigateToSeeAll(ExploreItemType.restaurant),
              ),
              ExploreHorizontalList(items: controller.restaurants),

              const SizedBox(height: 24),

              // =============> Hotels
              ExploreSectionHeader(
                title: "Best Hotels",
                onSeeAll: () =>
                    controller.navigateToSeeAll(ExploreItemType.hotel),
              ),
              ExploreHorizontalList(items: controller.hotels),

              const SizedBox(height: 24),

              // =============> Flights
              ExploreSectionHeader(
                title: "Upcoming Flights",
                onSeeAll: () =>
                    controller.navigateToSeeAll(ExploreItemType.flight),
              ),
              ExploreHorizontalList(items: controller.flights),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
