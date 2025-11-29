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
      height: 400,
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
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    child: Image.asset(place['image']!, fit: BoxFit.cover),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(1),
                        ],
                      ),
                    ),
                  ),
                  // Content
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
