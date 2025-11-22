import 'dart:async';
import 'package:egytravel_app/feature/home/data/model/destination_model.dart';
import 'package:egytravel_app/feature/home/data/model/place_model.dart';
import 'package:egytravel_app/feature/home/ui/widgets/filter_bottom_sheet.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Destination(image: Assets.imageCard, name: 'Cairo'),
    Destination(image: Assets.imageCard, name: 'Luxor'),
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
      'image': Assets.imageCard,
      'title': 'The Great Pyramid of Giza',
      'location': 'Giza Necropolis',
    },
    {
      'image': Assets.imageRectangle,
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
  IconData getCategoryIcon(String category) {
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
  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}