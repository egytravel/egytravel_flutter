import 'package:egytravel_app/feature/booking/logic/controller/booking_controller.dart';
import 'package:egytravel_app/feature/booking/ui/widgets/hotels/hotel_card.dart';
import 'package:egytravel_app/feature/booking/ui/widgets/hotels/hotel_search_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotelsTab extends StatelessWidget {
  const HotelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Form (Always visible)
          const HotelSearchForm(),

          // Results Section
          Obx(() {
            // Loading state
            if (controller.isSearchingHotels.value) {
              return const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: Color(0xFFE09A1E)),
              );
            }

            // Empty state (no search performed yet)
            if (!controller.hasSearchedHotels.value) {
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.hotel,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Search for hotels',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your destination and dates to find the best hotels',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              );
            }

            // No results found
            if (controller.hotelResults.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hotels found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search criteria',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Results Grid
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.hotelResults.length} hotels found',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Scroll to top to show search form
                        },
                        icon: const Icon(
                          Icons.tune,
                          size: 18,
                          color: Color(0xFFE09A1E),
                        ),
                        label: const Text(
                          'Modify Search',
                          style: TextStyle(
                            color: Color(0xFFE09A1E),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: controller.hotelResults.length,
                    itemBuilder: (context, index) {
                      return HotelCard(hotel: controller.hotelResults[index]);
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );
  }
}
