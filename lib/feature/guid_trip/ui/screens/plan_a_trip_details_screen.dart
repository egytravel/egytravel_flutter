import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:egytravel_app/feature/guid_trip/ui/widgets/day_input_card.dart';
import 'package:egytravel_app/feature/guid_trip/ui/widgets/guide_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlanATripDetailsScreen extends GetView<GuideTripController> {
  const PlanATripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              GuideAppBar(destination: controller.titleController.text),
              
              // ── Map Container ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Obx(() => GoogleMap(
                      onMapCreated: controller.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: controller.mapCenter.value,
                        zoom: 5,
                      ),
                      markers: controller.markers.value,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                    )),
                  ),
                ),
              ),

              Expanded(
                child: Obx(
                  () => NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      controller.updateFabVisibility(notification.direction);
                      return true;
                    },
                    child: ListView(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        // ── Hotel Card ──────────────────────────────────────
                        _HotelSelectionCard(),
                        
                        const SizedBox(height: 16),
                        
                        // ── Days List ───────────────────────────────────────
                        ...controller.days.map((day) => DayInputCard(day: day)).toList(),
                        
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // ── Bottom Action Bar (Confirm Button) ───────────────────────────────
        bottomSheet: _ConfirmActionBar(controller: controller),

        floatingActionButton: Obx(
          () => AnimatedScale(
            scale: controller.isFabVisible.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: FloatingActionButton(
                onPressed: controller.addDay,
                backgroundColor: Colors.orange,
                elevation: 10,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HotelSelectionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.hotel_rounded, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accomodation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Add a hotel to your trip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement hotel selection
              Get.snackbar('Coming Soon', 'Hotel booking integration is on the way!',
                  backgroundColor: Colors.orange.withOpacity(0.8),
                  colorText: Colors.white);
            },
            child: const Text('Add', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}

class _ConfirmActionBar extends StatelessWidget {
  final GuideTripController controller;

  const _ConfirmActionBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.saveTrip,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Confirm Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      )),
    );
  }
}
