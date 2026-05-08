import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:egytravel_app/feature/booking/data/models/flight_model.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FlightSelectionSheet extends StatefulWidget {
  const FlightSelectionSheet({Key? key}) : super(key: key);

  @override
  State<FlightSelectionSheet> createState() => _FlightSelectionSheetState();
}

class _FlightSelectionSheetState extends State<FlightSelectionSheet> {
  final controller = Get.find<GuideTripController>();
  final TextEditingController _fromController = TextEditingController(
    text: 'Cairo',
  );
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _toController.text = controller.destinationController.text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchFlightsForTrip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
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
                  'Search Flights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Search Form ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildSearchField(
                    controller: _fromController,
                    hint: 'From',
                    icon: Icons.flight_takeoff,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.swap_horiz, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSearchField(
                    controller: _toController,
                    hint: 'To',
                    icon: Icons.flight_land,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    controller.searchFlightsForTrip(
                      from: _fromController.text,
                      to: _toController.text,
                    );
                  },
                  icon: const Icon(Icons.search, color: Colors.orange),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Flight List ───────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isSearchingFlights.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              if (controller.flightResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flight_rounded,
                        color: Colors.white.withOpacity(0.1),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No flights found',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: controller.flightResults.length,
                itemBuilder: (context, index) {
                  final flight = controller.flightResults[index];
                  return _FlightCard(
                    flight: flight,
                    onAdd: () => _showDaySelectionDialog(context, flight),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.orange, size: 18),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  void _showDaySelectionDialog(BuildContext context, FlightModel flight) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add to Day', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.days.length,
            itemBuilder: (context, index) {
              final day = controller.days[index];
              return ListTile(
                title: Text(
                  'Day ${day.dayNumber}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  day.place.value,
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.addFlightToTripDay(
                    controller.createdTripId ?? '',
                    day.id ?? '',
                    flight,
                  );
                  Get.back(); // Close sheet
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onAdd;

  const _FlightCard({required this.flight, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.flight, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airlineName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        flight.flightNumber,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${flight.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo(
                  DateFormat('HH:mm').format(flight.departureTime),
                  flight.fromCity,
                  CrossAxisAlignment.start,
                ),
                Column(
                  children: [
                    Text(
                      flight.duration,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 10,
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 1,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    const Icon(
                      Icons.flight_takeoff,
                      color: Colors.white24,
                      size: 14,
                    ),
                  ],
                ),
                _buildTimeInfo(
                  DateFormat('HH:mm').format(flight.arrivalTime),
                  flight.toCity,
                  CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add to Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(
    String time,
    String city,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          city,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        ),
      ],
    );
  }
}
