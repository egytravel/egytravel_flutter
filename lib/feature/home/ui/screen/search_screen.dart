import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/home/logic/controller/search_controller.dart';
import 'package:egytravel_app/feature/home/ui/screen/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';

class SearchScreen extends GetView<AppSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: TextField(
                              controller: controller.searchTextField,
                              focusNode: controller.focusNode,
                              onChanged: controller.onSearchChanged,
                              onSubmitted: (value) {
                                controller.addToRecentSearches(value);
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search destinations...',
                                hintStyle: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 15,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white70,
                                  size: 22,
                                ),
                                suffixIcon: Obx(() => controller.isSearching.value
                                    ? IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white60, size: 20),
                                        onPressed: controller.clearSearch,
                                      )
                                    : const SizedBox.shrink()),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
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

              // Search Results
              Expanded(
                child: Obx(() {
                  if (!controller.isSearching.value) {
                    return _buildInitialState();
                  }

                  if (controller.filteredResults.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.filteredResults.length,
                    itemBuilder: (context, index) {
                      final place = controller.filteredResults[index];
                      return _buildSearchResultItem(
                        place.name,
                        place.location,
                        Icons.location_on_rounded,
                        imageUrl: place.image,
                        onTap: () {
                          controller.addToRecentSearches(place.name);
                          Get.to(
                            () => const PlaceDetailScreen(),
                            arguments: place,
                            transition: Transition.rightToLeftWithFade,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (controller.recentSearches.isNotEmpty) ...[
          _buildSectionTitle('Recent Searches'),
          const SizedBox(height: 12),
          ...controller.recentSearches.map((query) => _buildSearchResultItem(
                query,
                'Recent search',
                Icons.history,
                onTap: () {
                  controller.searchTextField.text = query;
                  controller.onSearchChanged(query);
                },
              )),
          const SizedBox(height: 24),
        ],
        _buildSectionTitle('Popular Destinations'),
        const SizedBox(height: 12),
        _buildSearchResultItem(
          'Pyramids of Giza',
          'Cairo, Egypt',
          Icons.landscape,
          onTap: () {
            controller.searchTextField.text = 'Pyramids of Giza';
            controller.onSearchChanged('Pyramids of Giza');
          },
        ),
        _buildSearchResultItem(
          'Luxor Temple',
          'Luxor, Egypt',
          Icons.account_balance_rounded,
          onTap: () {
            controller.searchTextField.text = 'Luxor Temple';
            controller.onSearchChanged('Luxor Temple');
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 80, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(String title, String subtitle, IconData icon,
      {String? imageUrl, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: ListTile(
              onTap: onTap,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(icon, color: Colors.white70, size: 20),
                      )
                    : Icon(icon, color: Colors.white70, size: 20),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white60,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
