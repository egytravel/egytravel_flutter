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

  List<ExploreItemModel> get placesForSelectedCategory {
    if (selectedPlaceCategory.value == 'Recent') {
      return allPlaces.take(5).toList();
    }
    return allPlaces
        .where((p) => p.category == selectedPlaceCategory.value)
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
      errorMessage.value = 'Something went wrong. Please try again.';
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

  void toggleFavorite(ExploreItemModel item) {
    item.isFavorite.value = !item.isFavorite.value;
  }
}
