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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.hasError.value) {
            return _buildErrorState();
          }

          return _buildContent();
        }),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white54,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.fetchExploreData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: controller.fetchExploreData,
      color: Colors.white,
      backgroundColor: const Color(0xFF0A1628),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
              categories: controller.placeCategories.toList(),
              selectedCategory: controller.selectedPlaceCategory,
              onCategoryChanged: controller.changePlaceCategory,
            ),
            const SizedBox(height: 16),

            // =============> Filtered Places (needs Obx — changes on category tap)
            Obx(
              () => ExploreHorizontalList(
                items: controller.placesForSelectedCategory,
                emptyMessage: "No places found in this category",
              ),
            ),
            const SizedBox(height: 20),

            // =============> Recommended
            ExploreSectionHeader(
              title: "Recommended",
              onSeeAll: () => controller.navigateToSeeAll(
                ExploreItemType.place,
                category: 'Recommended',
              ),
            ),
            ExploreHorizontalList(
              items: controller.recommendedPlaces.toList(),
            ),

            const SizedBox(height: 24),

            // =============> Restaurants
            ExploreSectionHeader(
              title: "Top Restaurants",
              onSeeAll: () =>
                  controller.navigateToSeeAll(ExploreItemType.restaurant),
            ),
            ExploreHorizontalList(items: controller.restaurants.toList()),

            const SizedBox(height: 24),

            // =============> Hotels
            ExploreSectionHeader(
              title: "Best Hotels",
              onSeeAll: () =>
                  controller.navigateToSeeAll(ExploreItemType.hotel),
            ),
            ExploreHorizontalList(items: controller.hotels.toList()),

            const SizedBox(height: 24),

            // =============> Flights
            ExploreSectionHeader(
              title: "Upcoming Flights",
              onSeeAll: () =>
                  controller.navigateToSeeAll(ExploreItemType.flight),
            ),
            ExploreHorizontalList(items: controller.flights.toList()),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
