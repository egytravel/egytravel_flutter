import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/location_badge.dart';
import 'package:egytravel_app/feature/home/ui/widgets/page_indicators.dart';

class HeroCarousel extends StatelessWidget {
  final HomeController controller;

  const HeroCarousel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.featuredPlaces.length,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final place = controller.featuredPlaces[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Container(
                    decoration: const BoxDecoration(

                    ),
                    child: Image.asset(place['image']!, fit: BoxFit.cover),
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
                  Positioned(
                    top: 100,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Egypt',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Discover Amazing\nDestinations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content at bottom
                  Positioned(
                    bottom: 80,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocationBadge(location: place['location']!),
                        const SizedBox(height: 12),
                        Text(
                          place['title']!,
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
  }
}
