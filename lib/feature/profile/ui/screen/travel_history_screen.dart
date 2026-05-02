import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelHistoryScreen extends StatelessWidget {
  const TravelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    controller.fetchTravelHistory();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Travel History'),
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
          if (controller.isLoadingHistory.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            );
          }

          if (controller.travelHistory.isEmpty) {
            return const EmptyStateWidget(
              title: 'No History Yet',
              message: 'Explore more places to build your travel history.',
              icon: Icons.history_rounded,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.travelHistory.length,
            itemBuilder: (context, index) {
              final item = controller.travelHistory[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.flight_takeoff_rounded, color: Colors.orangeAccent),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['destination'] ?? 'Destination',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['completed_at'] ?? 'May 2025',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 20),
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
