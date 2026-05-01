import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    controller.fetchFavorites();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF0D1B2E)],
          ),
        ),
        child: Obx(() {
          if (controller.isLoadingFavorites.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            );
          }

          if (controller.favorites.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Favorites Yet',
              message: 'Start exploring and save your favorite places here.',
              icon: Icons.favorite_outline_rounded,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.favorites.length,
            itemBuilder: (context, index) {
              final item = controller.favorites[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.white10,
                        child: const Icon(Icons.place_rounded, color: Colors.white24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? 'Place Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['type'] ?? 'Category',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
