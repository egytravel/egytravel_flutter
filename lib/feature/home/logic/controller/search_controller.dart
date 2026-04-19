import 'package:egytravel_app/feature/home/data/model/place_model.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSearchController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();
  final TextEditingController searchTextField = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxList<Place> filteredResults = <Place>[].obs;
  final RxList<String> recentSearches = <String>[
    'Giza Plateau',
    'Luxor Temple',
    'Sharm El Sheikh',
  ].obs;

  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Start with empty results or recommendations
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    
    // Combine all potential search targets
    final allPlaces = <Place>[
      ..._homeController.places,
      ..._homeController.featuredPlaces,
    ];

    // Simple case-insensitive search
    filteredResults.assignAll(
      allPlaces.where((place) =>
          place.name.toLowerCase().contains(query.toLowerCase()) ||
          place.location.toLowerCase().contains(query.toLowerCase())).toList(),
    );

    // Also search in destinations and map them to Place objects if needed
    // (Pattern from DestinationCard)
    for (var dest in _homeController.destinations) {
      if (dest.name.toLowerCase().contains(query.toLowerCase()) ||
          (dest.country?.toLowerCase().contains(query.toLowerCase()) ?? false)) {
        
        // Check if already added to results to avoid duplicates
        if (!filteredResults.any((p) => p.name == dest.name)) {
          filteredResults.add(Place(
            id: dest.id,
            name: dest.name,
            location: dest.country ?? 'Egypt',
            image: dest.image,
            rating: dest.rating ?? 4.5,
            price: 0, // Destination overview doesn't have a single price
            description: dest.description,
          ));
        }
      }
    }
  }

  void addToRecentSearches(String query) {
    if (query.trim().isEmpty) return;
    if (recentSearches.contains(query)) {
      recentSearches.remove(query);
    }
    recentSearches.insert(0, query);
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }
  }

  void clearSearch() {
    searchTextField.clear();
    filteredResults.clear();
    isSearching.value = false;
  }

  @override
  void onClose() {
    searchTextField.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
