import 'package:egytravel_app/feature/home/data/model/place_model.dart';
import 'package:egytravel_app/feature/home/ui/screen/details.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/location_badge.dart';
import 'package:egytravel_app/feature/home/ui/widgets/page_indicators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HeroCarousel extends StatelessWidget {
  final HomeController controller;

  const HeroCarousel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use dummy items for skeletonizer if loading and list is empty
      final list =
          (controller.isLoading.value && controller.featuredPlaces.isEmpty)
          ? [
              Place(
                name: 'Loading Name',
                location: 'Loading Location',
                image: '',
                rating: 0,
                price: 0,
              ),
              Place(
                name: 'Loading Name',
                location: 'Loading Location',
                image: '',
                rating: 0,
                price: 0,
              ),
            ]
          : controller.featuredPlaces;

      if (list.isEmpty && !controller.isLoading.value)
        return const SizedBox.shrink();

      return SizedBox(
        height: 380,
        child: Stack(
          children: [
            PageView.builder(
              controller: controller.pageController,
              itemCount: list.length,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              itemBuilder: (context, index) {
                final place = list[index];
                return GestureDetector(
                  onTap: () => Get.to(
                    () => const PlaceDetailScreen(),
                    arguments: place,
                    transition: Transition.fadeIn,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      Container(
                        color: const Color(0xFF1A2A44),
                        child: Skeleton.replace(
                          child: place.image.startsWith('http')
                              ? Image.network(
                                  place.image,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white24,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildPlaceholder(),
                                )
                              : _buildPlaceholder(),
                        ),
                      ),
                      // Enhanced gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0A1628).withOpacity(0.3),
                              const Color(0xFF0A1628).withOpacity(0.6),
                              const Color(0xFF0A1628).withOpacity(0.95),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Welcome greeting at top
                      // Positioned(
                      //   top: 100,
                      //   left: 24,
                      //   right: 24,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Explore Egypt',
                      //         style: TextStyle(
                      //           color: AppColor.primaryColor,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //           letterSpacing: 1.2,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 8),
                      //       const Text(
                      //         'Discover Amazing\nDestinations',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 32,
                      //           fontWeight: FontWeight.bold,
                      //           height: 1.2,
                      //           letterSpacing: -0.5,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Content at bottom
                      Positioned(
                        bottom: 80,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LocationBadge(location: place.location),
                            const SizedBox(height: 12),
                            Text(
                              place.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Page indicators
            Positioned(
              bottom: 50,
              right: 24,
              child: PageIndicators(controller: controller),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2A44), Color(0xFF0D1B2E)],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.place_rounded,
          color: Colors.white12,
          size: 64,
        ),
      ),
    );
  }
}
