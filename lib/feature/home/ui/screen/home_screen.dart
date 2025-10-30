import 'dart:async';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/ui/screen/details.dart';
import 'package:egytravel_app/feature/profile/ui/screen/profile_screen.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ============== Models ==============

class Place {
  final String name;
  final String location;
  final String image;
  final double rating;
  final String season;
  final String price;

  Place({
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.season,
    required this.price,
  });
}

class Destination {
  final String image;
  final String name;

  Destination({required this.image, required this.name});
}

// ============== Controller ==============

class HomeController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  Timer? _timer;
  final searchController = TextEditingController();
  final selectedCategory = 'Popular'.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final scrollOpacity = 0.0.obs;

  final categories = ['Popular', 'Pyramids', 'Beach', 'Temple'];

  final places = [
    Place(
      name: 'Valley of the Kings',
      location: 'Luxor',
      image: Assets.imageCard,
      rating: 4.8,
      season: '302N',
      price: '\$ 300/p',
    ),
    Place(
      name: 'Abu Simbel',
      location: 'Aswan',
      image: Assets.imageCard,
      rating: 4.6,
      season: '302N',
      price: '\$ 420/p',
    ),
  ];

  final destinations = [
    Destination(image: 'assets/dest1.jpg', name: 'Cairo'),
    Destination(image: 'assets/dest2.jpg', name: 'Luxor'),
  ];

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openFilter() {
    Get.bottomSheet(
      const FilterBottomSheet(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  final featuredPlaces = [
    {
      'image': Assets.imageEnterPassword,
      'title': 'The Great Pyramid of Giza',
      'location': 'Giza Necropolis',
    },
    {
      'image': Assets.imageForgetPassword,
      'title': 'The Great Sphinx',
      'location': 'Giza Plateau',
    },
    {
      'image': Assets.imageOnboarding1,
      'title': 'Karnak Temple',
      'location': 'Luxor',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // حساب الـ opacity بناءً على الـ scroll position
    final offset = scrollController.offset;
    final maxScroll = 500.0; // المسافة اللي بعدها يوصل الأسود لأقصاه
    scrollOpacity.value = (offset / maxScroll).clamp(0.0, 0.7);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage.value < featuredPlaces.length - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }

      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

// ============== Main Screen ==============

class TraveliteHomeScreen extends StatelessWidget {
  const TraveliteHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.0),
            Colors.black.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: IconButton(
                onPressed: () {
                  Get.to(() => const ProfileScreen());
                },
                icon: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // الخلفية المتدرجة
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(controller.scrollOpacity.value),
                    ],
                  ),
                ),
              ),
            ),
            // المحتوى
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),

              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الصورة اللي بتسكرول
                    SizedBox(
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
                                  // الصورة
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(40),
                                        bottomLeft: Radius.circular(40),
                                      ),
                                    ),
                                    child: Image.asset(
                                      place['image']!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Gradient overlay - الأسود الخفيف
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha:0.0),
                                          Colors.black.withValues(alpha:1),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // المحتوى
                                  Positioned(
                                    bottom: 40,
                                    left: 24,
                                    right: 24,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                place['location']!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                            child: Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    controller.featuredPlaces.length,
                                    (index) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      width:
                                          controller.currentPage.value == index
                                          ? 20
                                          : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color:
                                            controller.currentPage.value ==
                                                index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search destinations...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF64748B),
                              size: 22,
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: controller.openFilter,
                                icon: const Icon(
                                  Icons.tune_rounded,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Categories Section
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Obx(
                              () => Row(
                                children: controller.categories.map((category) {
                                  final isSelected =
                                      controller.selectedCategory.value ==
                                      category;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: GestureDetector(
                                      onTap: () =>
                                          controller.selectedCategory.value =
                                              category,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color(0xFFFF6B35),
                                                    Color(0xFFFF8E53),
                                                  ],
                                                )
                                              : null,
                                          color: isSelected
                                              ? null
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? const Color(
                                                      0xFFFF6B35,
                                                    ).withOpacity(0.3)
                                                  : Colors.black.withOpacity(
                                                      0.05,
                                                    ),
                                              blurRadius: isSelected ? 12 : 8,
                                              offset: Offset(
                                                0,
                                                isSelected ? 4 : 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              _getCategoryIcon(category),
                                              size: 18,
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF64748B),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              category,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : const Color(0xFF64748B),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Popular Places Section
                    Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Column(
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
                                    color: Color(0xFF2D3748),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(
                                      () => const SaintMoritzDetailScreen(),
                                    );
                                  },
                                  child: const Text(
                                    'See All',
                                    style: TextStyle(
                                      color: Color(0xFFFF6B35),
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
                              children: controller.places.map((place) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: PlaceCard(place: place),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Destinations Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Destination',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Explore',
                                  style: TextStyle(
                                    color: Color(0xFFFF6B35),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: controller.destinations.map((dest) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: DestinationCard(destination: dest),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColor.primary,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: AppColor.primary.withValues(alpha: 0.7),
          items: [
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsHome),
              ),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsSearch),
              ),
              label: 'Search',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsExplore),
              ),
              label: 'Explore',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsProfile),
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {},
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Popular':
        return Icons.local_fire_department_rounded;
      case 'Pyramids':
        return Icons.account_balance_rounded;
      case 'Beach':
        return Icons.beach_access_rounded;
      case 'Temple':
        return Icons.temple_buddhist_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

// ============== Place Card ==============

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(place.image),
                fit: BoxFit.cover,
                onError: (_, __) {},
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    place.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    place.season,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                color: Colors.white.withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Color(0xFF8B7355),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.location,
                        style: const TextStyle(
                          color: Color(0xFF8B7355),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2416),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BFA6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============== Destination Card ==============

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(destination.image),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
                color: const Color(0xFFE2E8F0),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============== Drawer ==============

// ============== Filter Bottom Sheet ==============

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildFilterSection('Price Range', [
                  'Under \$100',
                  '\$100 - \$500',
                  '\$500 - \$1000',
                  'Above \$1000',
                ]),
                const SizedBox(height: 24),
                _buildFilterSection('Rating', [
                  '5 Stars',
                  '4 Stars & Above',
                  '3 Stars & Above',
                  'All Ratings',
                ]),
                const SizedBox(height: 24),
                _buildFilterSection('Location', [
                  'Cairo',
                  'Giza',
                  'Luxor',
                  'Aswan',
                  'Alexandria',
                  'Hurghada',
                ]),
                const SizedBox(height: 24),
                _buildFilterSection('Activities', [
                  'Historical Sites',
                  'Beach & Water',
                  'Adventure',
                  'Cultural',
                  'Shopping',
                ]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: const Color(0xFFFF6B35).withOpacity(0.3),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              onSelected: (selected) {},
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFFF6B35).withOpacity(0.15),
              checkmarkColor: const Color(0xFFFF6B35),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}
