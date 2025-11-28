import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/trip_itinerary_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/models/trip_itinerary_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaysNavigationBar extends StatelessWidget {
  const DaysNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripItineraryController>(
      builder: (controller) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.tripDays.length,
            itemBuilder: (context, index) {
              bool isSelected = controller.selectedDayIndex == index;
              DayItinerary day = controller.tripDays[index];

              return GestureDetector(
                onTap: () {
                  controller.selectDay(index);
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                    color: isSelected ? Colors.deepOrange : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.deepOrange : Colors.grey[300]!,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Day ${day.dayNumber}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.deepOrange : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd').format(day.date),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.deepOrange : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
