import 'dart:async';
import 'package:egytravel_app/feature/home/data/model/destination_model.dart';
import 'package:egytravel_app/feature/home/data/model/place_model.dart';
import 'package:egytravel_app/feature/home/data/repo/home_repo.dart';
import 'package:egytravel_app/feature/home/ui/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeRepo _homeRepo = HomeRepo();
  
  final pageController = PageController();
  final currentPage = 0.obs;
  Timer? _timer;
  final searchController = TextEditingController();
  final selectedCategory = 'Popular'.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final scrollOpacity = 0.0.obs;
  final isScrolled = false.obs;

  // State Management
  final isLoading = true.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  final categories = ['Popular', 'Pyramids', 'Beach', 'Temple'];

  // Data Lists
  final RxList<Place> places = <Place>[].obs;
  final RxList<Destination> destinations = <Destination>[].obs;
  final RxList<Place> featuredPlaces = <Place>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHomeData();
    scrollController.addListener(_onScroll);
  }

  Future<void> getHomeData() async {
    try {
      isLoading.value = true;
      isError.value = false;
      
      final response = await _homeRepo.getHomeData();
      
      places.assignAll(response.popular);
      destinations.assignAll(response.destinations);
      featuredPlaces.assignAll(response.featured);
      
      _startAutoScroll();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

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

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final offset = scrollController.offset;
    // Change app bar color when scrolled past 100 pixels
    isScrolled.value = offset > 100;

    // Calculate opacity for other scroll effects
    const maxScroll = 500.0;
    scrollOpacity.value = (offset / maxScroll).clamp(0.0, 0.7);
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (featuredPlaces.isEmpty) return;
    
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!pageController.hasClients) return;

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

