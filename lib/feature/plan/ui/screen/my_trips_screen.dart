import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/plan/logic/controller/saved_trips_controller.dart';
import 'package:egytravel_app/feature/plan/ui/screen/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedTripsController());

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CustomBackButton(),
          title: const Text(
            'My Planned Trips',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () => controller.fetchTrips(),
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.trips.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          if (controller.trips.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchTrips(),
            color: Colors.orange,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.trips.length,
              itemBuilder: (context, index) {
                final trip = controller.trips[index];
                return _buildTripCard(context, trip, controller);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, dynamic trip, SavedTripsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          trip.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text(
                  trip.destination ?? 'No destination',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatDateRange(trip.startDate, trip.endDate),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _showDeleteDialog(context, trip, controller),
        ),
        onTap: () {
          Get.to(
            () => TripDetailsScreen(tripId: trip.id),
            transition: Transition.cupertino,
          );
        },
      ),
    );
  }

  String _formatDateRange(String? start, String? end) {
    if (start == null || end == null) return 'Dates not set';
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      return '${DateFormat('MMM d').format(s)} - ${DateFormat('MMM d, yyyy').format(e)}';
    } catch (_) {
      return 'Invalid dates';
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.luggage_outlined, size: 80, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'No trips planned yet',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Start planning your next adventure!',
            style: TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic trip, SavedTripsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text('Delete Trip', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${trip.title}"?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTrip(trip.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
