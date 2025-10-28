import 'dart:async';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
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

  final categories = ['Popular', 'Pyramids', 'Beach', 'Temple'];

  final places = [
    Place(
      name: 'Valley of the Kings',
      location: 'Luxor',
      image: 'assets/valley_kings.jpg',
      rating: 4.8,
      season: '302N',
      price: '\$ 390/p',
    ),
    Place(
      name: 'Abu Simbel',
      location: 'Aswan',
      image: 'assets/abu_simbel.jpg',
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
      'image':Assets.imageOnboarding1,
      'title': 'Karnak Temple',
      'location': 'Luxor',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
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

    return Scaffold(
      key: controller.scaffoldKey,
      drawer: const TraveliteDrawer(),
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // Custom AppBar that shrinks
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            leading: IconButton(
              onPressed: controller.openDrawer,
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
            centerTitle: true,
            title: const Text(
              'Travelite',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(Assets.iconsProfile),
                  onBackgroundImageError: (_, __) {},
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.grey[800],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [

                  // Auto-scrolling PageView
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
                          // Featured Image
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(place['image']!),
                                fit: BoxFit.cover,
                                onError: (_, __) {},
                              ),
                              color: Colors.grey[800],
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          // Text overlay
                          Positioned(
                            bottom: 60,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  place['location']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Page indicators (dots)
                  Positioned(
                    bottom: 70,
                    right: 16,
                    child: Obx(() => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(

                        controller.featuredPlaces.length,
                            (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: controller.currentPage.value == index ? 8 : 6,
                          height: controller.currentPage.value == index ? 8 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentPage.value == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
          // Pinned Search Bar
          SliverAppBar(
            pinned: true,
            floating: false,
            toolbarHeight: 80,
            backgroundColor: Colors.grey[800],
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              color: Colors.grey[800],
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: IconButton(
                      onPressed: controller.openFilter,
                      icon: Icon(Icons.tune, color: Colors.grey[700]),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Categories
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() => Row(
                  children: controller.categories.map((category) {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () =>
                        controller.selectedCategory.value = category,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                            isSelected ? Colors.orange : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category),
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
              ),
            ),
          ),
          // Places list
          SliverToBoxAdapter(
            child: Container(
              color:Colors.grey[900],
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: controller.places.map((place) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: PlaceCard(place: place),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Destination section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Destination',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: controller.destinations.map((dest) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: DestinationCard(destination: dest),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(

        color: AppColor.primary,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColor.primary.withValues(alpha: 0.5),
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
            label: 'Explore ',
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
        onTap: (index) {
          // Handle button tap
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Popular':
        return Icons.local_fire_department;
      case 'Pyramids':
        return Icons.account_balance;
      case 'Beach':
        return Icons.beach_access;
      case 'Temple':
        return Icons.temple_buddhist;
      default:
        return Icons.category;
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
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(place.image),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                  color: Colors.grey[300],
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.rating.toString(),
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
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny,
                        color: Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.season,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      place.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
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
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(destination.image),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
        color: Colors.grey[300],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============== Bottom Navigation ==============

class TraveliteBottomNav extends StatelessWidget {
  const TraveliteBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', true),
              _buildNavItem(Icons.search, 'Search', false),
              _buildNavItem(Icons.explore, 'Explore', false),
              _buildNavItem(Icons.message, 'Message', false),
              _buildNavItem(Icons.person, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.orange : Colors.grey,
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.orange : Colors.grey,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ============== Drawer ==============

class TraveliteDrawer extends StatelessWidget {
  const TraveliteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    onBackgroundImageError: (_, __) {},
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'user@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', () {}),
            _buildDrawerItem(Icons.bookmark, 'My Bookings', () {}),
            _buildDrawerItem(Icons.favorite, 'Favorites', () {}),
            _buildDrawerItem(Icons.settings, 'Settings', () {}),
            _buildDrawerItem(Icons.help, 'Help & Support', () {}),
            const Divider(),
            _buildDrawerItem(Icons.logout, 'Logout', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ============== Filter Bottom Sheet ==============

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _buildFilterSection('Rating', [
                  '5 Stars',
                  '4 Stars & Above',
                  '3 Stars & Above',
                  'All',
                ]),
                const SizedBox(height: 20),
                _buildFilterSection('Location', [
                  'Cairo',
                  'Giza',
                  'Luxor',
                  'Aswan',
                  'Alexandria',
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply',
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
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              onSelected: (selected) {},
              selectedColor: Colors.orange.withOpacity(0.2),
              checkmarkColor: Colors.orange,
            );
          }).toList(),
        ),
      ],
    );
  }
}