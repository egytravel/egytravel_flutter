import 'package:egytravel_app/feature/booking/ui/widgets/hotels/hotel_card.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotelSelectionSheet extends GetView<GuideTripController> {
  const HotelSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Start search when sheet opens if results are empty
    if (controller.hotelResults.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.searchHotelsForTrip();
      });
    }

    return Container(
      height: Get.height * 0.8,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: const Color(0xFF121212),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Accommodation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          
          // ── City Search Bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: controller.destinationController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search city (e.g. Cairo)',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.orange, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.orange, size: 20),
                    onPressed: () => controller.searchHotelsForTrip(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => controller.searchHotelsForTrip(),
              ),
            ),
          ),
          
          const Divider(color: Colors.white10),
          Expanded(
            child: Obx(() {
              if (controller.isSearchingHotels.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              if (controller.hotelResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        size: 64,
                        color: Colors.white24,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hotels found',
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () => controller.searchHotelsForTrip(),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.hotelResults.length,
                itemBuilder: (context, index) {
                  final hotel = controller.hotelResults[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Stack(
                      children: [
                        HotelCard(hotel: hotel),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.days.isEmpty) {
                                Get.snackbar('Error', 'Please add a day to your trip first');
                                return;
                              }

                              // Show Day Selection Dialog
                              Get.dialog(
                                Center(
                                  child: Container(
                                    width: Get.width * 0.8,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1E1E),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Select Day',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller.days.length,
                                            itemBuilder: (context, dIndex) {
                                              final day = controller.days[dIndex];
                                              return ListTile(
                                                title: Text(
                                                  'Day ${day.dayNumber} - ${day.place.value.isNotEmpty ? day.place.value : 'No Title'}',
                                                  style: const TextStyle(color: Colors.white70),
                                                ),
                                                trailing: const Icon(Icons.add, color: Colors.orange),
                                                onTap: () {
                                                  Get.back(); // Close Dialog
                                                  controller.addHotelToTripDay(
                                                    controller.createdTripId ?? '',
                                                    day.id ?? '',
                                                    hotel,
                                                  );
                                                  Get.back(); // Close Sheet
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              minimumSize: const Size(0, 36),
                            ),
                            child: const Text('Add to Trip'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
