import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  // --- Recommended Places ---
  final List<ExploreItemModel> recommendedPlaces = [
    ExploreItemModel(
      title: 'Karnak Temple',
      location: 'Luxor',
      image: Assets.imageOnboarding1,
      rating: 4.9,
      price: '\$25',
      category: 'Historical',
      type: ExploreItemType.place,
    ),
    ExploreItemModel(
      title: 'Naama Bay',
      location: 'Sharm El Sheikh',
      image: Assets.imageRectangle,
      rating: 4.7,
      price: 'Free',
      category: 'Beaches',
      type: ExploreItemType.place,
    ),
  ];

  // --- Places Section (By Category) ---
  final placeCategories = [
    'Recent', // Default/All
    'Historical',
    'Beaches',
    'Religious',
    'Entertainment',
    'Nature & Adventure',
  ];

  final selectedPlaceCategory = 'Recent'.obs;

  List<ExploreItemModel> get placesForSelectedCategory {
    // Mocking filtering logic - In real app, fetch from DB/API
    if (selectedPlaceCategory.value == 'Recent') {
      return _allPlaces.take(5).toList();
    }
    return _allPlaces
        .where((p) => p.category == selectedPlaceCategory.value)
        .toList();
  }

  // Mock Repository of Places
  final List<ExploreItemModel> _allPlaces = [
    ExploreItemModel(
      title: 'Pyramids of Giza',
      location: 'Giza',
      image: Assets.imageCard,
      rating: 4.9,
      price: '\$50',
      category: 'Historical',
      type: ExploreItemType.place,
    ),
    ExploreItemModel(
      title: 'Valley of the Kings',
      location: 'Luxor',
      image: Assets.imageDetail, // Using detail image for variety
      rating: 4.8,
      price: '\$40',
      category: 'Historical',
      type: ExploreItemType.place,
    ),
    ExploreItemModel(
      title: 'Blue Hole',
      location: 'Dahab',
      image: Assets.imageRectangle,
      rating: 4.7,
      price: 'Free',
      category: 'Beaches',
      type: ExploreItemType.place,
    ),
    ExploreItemModel(
      title: 'Saint Catherine',
      location: 'Sinai',
      image: Assets.imageOnboarding2,
      rating: 4.8,
      price: '\$10',
      category: 'Religious',
      type: ExploreItemType.place,
    ),
    ExploreItemModel(
      title: 'Cairo Festival City',
      location: 'New Cairo',
      image: Assets.imageCard,
      rating: 4.5,
      price: 'Free',
      category: 'Entertainment',
      type: ExploreItemType.place,
    ),
    ExploreItemModel(
      title: 'White Desert',
      location: 'Farafra',
      image: Assets.imageOnboarding3,
      rating: 4.9,
      price: '\$100',
      category: 'Nature & Adventure',
      type: ExploreItemType.place,
    ),
  ];

  // --- Restaurants Section ---
  final List<ExploreItemModel> restaurants = [
    ExploreItemModel(
      title: 'Abou El Sid',
      location: 'Zamalek, Cairo',
      image: Assets.imageCard,
      rating: 4.5,
      price: '\$\$',
      category: 'Egyptian',
      type: ExploreItemType.restaurant,
      cuisine: 'Authentic Egyptian',
    ),
    ExploreItemModel(
      title: 'Andrea Mariouteya',
      location: 'Giza',
      image: Assets.imageCard,
      rating: 4.3,
      price: '\$\$',
      category: 'Grill',
      type: ExploreItemType.restaurant,
      cuisine: 'Grill & Breakfast',
    ),
    ExploreItemModel(
      title: 'Ovio',
      location: 'Maadi, Cairo',
      image: Assets.imageCard,
      rating: 4.6,
      price: '\$\$\$',
      category: 'European',
      type: ExploreItemType.restaurant,
      cuisine: 'European Fusion',
    ),
    ExploreItemModel(
      title: 'Fish Market',
      location: 'Alexandria',
      image: Assets.imageCard,
      rating: 4.7,
      price: '\$\$\$',
      category: 'Seafood',
      type: ExploreItemType.restaurant,
      cuisine: 'Fresh Seafood',
    ),
  ];

  // --- Hotels Section ---
  final List<ExploreItemModel> hotels = [
    ExploreItemModel(
      title: 'Old Cataract',
      location: 'Aswan',
      image: Assets.imageCard,
      rating: 5.0,
      price: '\$400/night',
      category: 'Luxury',
      type: ExploreItemType.hotel,
      features: 'Nil View, Historic',
    ),
    ExploreItemModel(
      title: 'Four Seasons',
      location: 'Cairo',
      image: Assets.imageCard,
      rating: 4.9,
      price: '\$350/night',
      category: 'Luxury',
      type: ExploreItemType.hotel,
      features: 'Pool, Spa',
    ),
    ExploreItemModel(
      title: 'Al Moudira',
      location: 'Luxor',
      image: Assets.imageCard,
      rating: 4.8,
      price: '\$200/night',
      category: 'Boutique',
      type: ExploreItemType.hotel,
      features: 'Arabesque Design',
    ),
    ExploreItemModel(
      title: 'Rixos Premium',
      location: 'Sharm',
      image: Assets.imageCard,
      rating: 4.7,
      price: '\$300/night',
      category: 'Resort',
      type: ExploreItemType.hotel,
      features: 'All Inclusive',
    ),
  ];

  // --- Flights Section ---
  final List<ExploreItemModel> flights = [
    ExploreItemModel(
      title: 'CAI - LXR',
      location: 'Cairo to Luxor',
      image: Assets.imageCard,
      rating: 4.5,
      price: '\$100',
      category: 'Economy',
      type: ExploreItemType.flight,
      date: '12 Oct - 08:30 AM',
    ),
    ExploreItemModel(
      title: 'CAI - ASW',
      location: 'Cairo to Aswan',
      image: Assets.imageCard,
      rating: 4.6,
      price: '\$120',
      category: 'Economy',
      type: ExploreItemType.flight,
      date: '14 Oct - 10:00 AM',
    ),
    ExploreItemModel(
      title: 'CAI - HRG',
      location: 'Cairo to Hurghada',
      image: Assets.imageCard,
      rating: 4.3,
      price: '\$90',
      category: 'Economy',
      type: ExploreItemType.flight,
      date: '20 Oct - 07:45 AM',
    ),
    ExploreItemModel(
      title: 'CAI - SSH',
      location: 'Cairo to Sharm',
      image: Assets.imageCard,
      rating: 4.4,
      price: '\$95',
      category: 'Economy',
      type: ExploreItemType.flight,
      date: '22 Oct - 09:15 AM',
    ),
  ];

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
