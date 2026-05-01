import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/data/repo/explore_repo.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  final ExploreRepo _repo;

  ExploreController({ExploreRepo? repo}) : _repo = repo ?? ExploreRepo();

  // --- State ---
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // --- Data ---
  final placeCategories = <String>[].obs;
  final allPlaces = <ExploreItemModel>[].obs;
  final recommendedPlaces = <ExploreItemModel>[].obs;
  final restaurants = <ExploreItemModel>[].obs;
  final hotels = <ExploreItemModel>[].obs;
  final flights = <ExploreItemModel>[].obs;

  final selectedPlaceCategory = 'Recent'.obs;

  List<ExploreItemModel> get dummyItems => List.generate(
        5,
        (index) => ExploreItemModel(
          id: 'skeleton_$index',
          title: 'Place Name Placeholder',
          location: 'Location Placeholder',
          image: '',
          rating: 5.0,
          price: '\$100',
          category: 'Category',
          type: ExploreItemType.place,
        ),
      );

  List<ExploreItemModel> get placesForSelectedCategory {
    final category = selectedPlaceCategory.value;
    if (category == 'Recent') {
      return allPlaces.take(5).toList();
    }
    if (category == 'All') {
      return allPlaces.toList();
    }
    return allPlaces
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchExploreData();
  }

  Future<void> fetchExploreData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _repo.getExploreData();

      placeCategories.assignAll(response.categories);
      allPlaces.assignAll(response.places);
      recommendedPlaces.assignAll(response.recommended);
      restaurants.assignAll(response.restaurants);
      hotels.assignAll(response.hotels);
      flights.assignAll(response.flights);

      // Default selected category
      if (placeCategories.isNotEmpty) {
        selectedPlaceCategory.value = placeCategories.first;
      }
    } on ApiError catch (e) {
      hasError.value = true;
      errorMessage.value = e.message;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void changePlaceCategory(String category) {
    selectedPlaceCategory.value = category;
  }

  void navigateToSeeAll(ExploreItemType type, {String? category}) {
    Get.toNamed(
      Routes.exploreListing,
      arguments: {'type': type, 'category': category},
    );
  }

  void openMapView() {
    Get.toNamed(Routes.mapView);
  }

  final searchQuery = ''.obs;

  List<ExploreItemModel> getItemsForListing(ExploreItemType? type, String? category) {
    List<ExploreItemModel> baseList;
    if (type == null) {
      baseList = allPlaces;
    } else {
      switch (type) {
        case ExploreItemType.place:
          baseList = allPlaces;
          break;
        case ExploreItemType.restaurant:
          baseList = restaurants;
          break;
        case ExploreItemType.hotel:
          baseList = hotels;
          break;
        case ExploreItemType.flight:
          baseList = flights;
          break;
      }
    }

    // Filter by category if provided
    if (category != null && category != 'All' && category != 'Explore') {
      if (category == 'Recommended') {
        baseList = baseList.where((p) => p.isRecommended).toList();
      } else {
        baseList = baseList.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
      }
    }

    return _filterBySearch(baseList);
  }

  List<ExploreItemModel> _filterBySearch(List<ExploreItemModel> list) {
    if (searchQuery.isEmpty) return list.toList();
    final query = searchQuery.value.toLowerCase();
    return list
        .where((item) =>
            item.title.toLowerCase().contains(query) ||
            item.location.toLowerCase().contains(query))
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleFavorite(ExploreItemModel item) {
    item.isFavorite.value = !item.isFavorite.value;
  }
}
