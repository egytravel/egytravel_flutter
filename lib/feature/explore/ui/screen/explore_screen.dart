import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_controller.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_app_bar.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_category_list.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_horizontal_list.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/explore/explore_section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExploreScreen extends GetView<ExploreController> {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ExploreController>()) {
      Get.put(ExploreController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628), // Guarantee opaque background
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => ExploreAppBar(
            onMapPressed: controller.openMapView,
            isScrolled: controller.isScrolled.value,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0A1628),
              Color(0xFF0D1B2E),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Obx(() {
          if (controller.hasError.value && !controller.isLoading.value) {
            return _buildErrorState();
          }

          return Skeletonizer(
            enabled: controller.isLoading.value,
            child: _buildContent(),
          );
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
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =============> Explore Places Section
            const SizedBox(height: 50), // Starting position for content
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Explore Places",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category Chips
            ExploreCategoryList(
              categories: controller.isLoading.value && controller.placeCategories.isEmpty
                  ? ['Recent', 'Beach', 'Mountain', 'City']
                  : controller.placeCategories.toList(),
              selectedCategory: controller.selectedPlaceCategory,
              onCategoryChanged: controller.changePlaceCategory,
            ),
            const SizedBox(height: 16),

            // =============> Filtered Places (needs Obx — changes on category tap)
            Obx(
              () => ExploreHorizontalList(
                listId: 'places',
                items: controller.isLoading.value && controller.allPlaces.isEmpty
                    ? controller.dummyItems
                    : controller.placesForSelectedCategory,
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
              listId: 'recommended',
              items: controller.isLoading.value && controller.recommendedPlaces.isEmpty
                  ? controller.dummyItems
                  : controller.recommendedPlaces.toList(),
            ),

            const SizedBox(height: 24),

            // =============> Restaurants
            ExploreSectionHeader(
              title: "Top Restaurants",
              onSeeAll: () =>
                  controller.navigateToSeeAll(ExploreItemType.restaurant),
            ),
            ExploreHorizontalList(
              listId: 'restaurants',
              items: controller.isLoading.value && controller.restaurants.isEmpty
                  ? controller.dummyItems
                  : controller.restaurants.toList(),
            ),

            const SizedBox(height: 24),

            // =============> Hotels
            ExploreSectionHeader(
              title: "Best Hotels",
              onSeeAll: () =>
                  controller.navigateToSeeAll(ExploreItemType.hotel),
            ),
            ExploreHorizontalList(
              listId: 'hotels',
              items: controller.isLoading.value && controller.hotels.isEmpty
                  ? controller.dummyItems
                  : controller.hotels.toList(),
            ),

            const SizedBox(height: 24),

            // =============> Flights
            ExploreSectionHeader(
              title: "Upcoming Flights",
              onSeeAll: () =>
                  controller.navigateToSeeAll(ExploreItemType.flight),
            ),
            ExploreHorizontalList(
              listId: 'flights',
              items: controller.isLoading.value && controller.flights.isEmpty
                  ? controller.dummyItems
                  : controller.flights.toList(),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
