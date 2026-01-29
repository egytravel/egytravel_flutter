import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/listing/explore_grid.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/listing/explore_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreListingScreen extends StatefulWidget {
  const ExploreListingScreen({super.key});

  @override
  State<ExploreListingScreen> createState() => _ExploreListingScreenState();
}

class _ExploreListingScreenState extends State<ExploreListingScreen> {
  final ExploreItemType? type = Get.arguments?['type'];
  final String? initialCategory = Get.arguments?['category'];
  List<ExploreItemModel> items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    items = List.generate(
      10,
      (index) => ExploreItemModel(
        title: 'Item $index',
        location: 'Location $index',
        image: 'assets/images/card.png',
        rating: 4.5,
        price: '\$${index * 10}',
        category: 'Category',
        type: type ?? ExploreItemType.place,
        date: type == ExploreItemType.flight ? '12 Oct' : null,
        isFavorite: false, // Initialize favorite state
      ),
    );
  }

  String get screenTitle {
    String title = "Explore";
    if (type != null) {
      switch (type!) {
        case ExploreItemType.place:
          title = "Places";
          break;
        case ExploreItemType.restaurant:
          title = "Restaurants";
          break;
        case ExploreItemType.hotel:
          title = "Hotels";
          break;
        case ExploreItemType.flight:
          title = "Flights";
          break;
      }
    }
    if (initialCategory != null) {
      title = "$initialCategory $title";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            screenTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            ExploreSearchBar(onFilterPressed: () {}),
            Expanded(child: ExploreGrid(items: items)),
          ],
        ),
      ),
    );
  }
}
