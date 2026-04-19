import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/data/model/place_model.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/place_card.dart';
import 'package:egytravel_app/feature/home/ui/screen/details.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/screen/explore_listing_screen.dart';
import 'package:get/get.dart';

class PopularPlacesSection extends StatelessWidget {
  final HomeController controller;

  const PopularPlacesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use dummy items for skeletonizer if loading and list is empty
      final list = (controller.isLoading.value && controller.places.isEmpty)
          ? List.generate(
              3,
              (index) => Place(
                name: 'Loading Place Name',
                location: 'Loading Location',
                image: '',
                rating: 0,
                price: 0,
              ),
            )
          : controller.places;

      if (list.isEmpty && !controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Places',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () => {
                    Get.to(
                      () => const ExploreListingScreen(),
                      arguments: {'type': ExploreItemType.place},
                      transition: Transition.rightToLeftWithFade,
                    ),
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: list.map((place) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () => Get.to(
                      () => const PlaceDetailScreen(),
                      arguments: place,
                      transition: Transition.rightToLeftWithFade,
                    ),
                    child: PlaceCard(place: place),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}
