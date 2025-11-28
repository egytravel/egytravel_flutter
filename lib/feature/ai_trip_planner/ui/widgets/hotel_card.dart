import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/trip_itinerary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotelCard extends StatelessWidget {
  final String hotelName;
  final int dayIndex;

  const HotelCard({
    Key? key,
    required this.hotelName,
    required this.dayIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.hotel,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Accommodation',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => _showEditHotelDialog(context, hotelName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hotelName,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(
                5,
                (index) =>
                    const Icon(Icons.star, size: 16, color: Colors.amber),
              ),
              const SizedBox(width: 8),
              Text(
                '4.5 (${120 + dayIndex * 10} reviews)',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditHotelDialog(BuildContext context, String currentHotel) {
    List<String> hotelOptions = [
      'Grand Luxury Resort & Spa',
      'Comfort Inn & Suites',
      'Cozy Budget Hotel',
      'Seaside Paradise Hotel',
      'Downtown Business Hotel',
      'Family Friendly Resort',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Hotel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: hotelOptions.map((hotel) {
            return RadioListTile<String>(
              title: Text(hotel),
              value: hotel,
              groupValue: currentHotel,
              activeColor: Colors.deepOrange,
              onChanged: (value) {
                if (value != null) {
                  final controller = Get.find<TripItineraryController>();
                  controller.updateHotel(dayIndex, value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hotel changed to: $value'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
