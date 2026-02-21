import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/trip_itinerary_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/activity_card.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/days_navigation_bar.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/flight_card.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/hotel_card.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/trip_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripItineraryBody extends StatelessWidget {
  const TripItineraryBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripItineraryController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.deepOrange),
                const SizedBox(height: 16),
                Text(
                  'Creating your perfect itinerary...',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        int totalDays = controller.endDate.difference(controller.startDate).inDays + 1;

        if (controller.tripDays.isEmpty || controller.selectedDayIndex >= controller.tripDays.length) {
          return const SizedBox();
        }

        return Column(
          children: [
            TripSummaryCard(
              totalDays: totalDays,
              budget: controller.budget,
            ),
            const DaysNavigationBar(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.tripDays[controller.selectedDayIndex].flight != null)
                    FlightCard(
                      flight: controller.tripDays[controller.selectedDayIndex].flight!,
                      dayIndex: controller.selectedDayIndex,
                    ),
                  HotelCard(
                    hotelName: controller.tripDays[controller.selectedDayIndex].hotel,
                    dayIndex: controller.selectedDayIndex,
                  ),
                  const SizedBox(height: 16),
                  _buildActivitiesSection(controller),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivitiesSection(TripItineraryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...controller.tripDays[controller.selectedDayIndex].activities.asMap().entries.map((entry) {
          int index = entry.key;
          var activity = entry.value;
          return ActivityCard(
            activity: activity,
            index: index,
            dayIndex: controller.selectedDayIndex,
          );
        }).toList(),
      ],
    );
  }
}
