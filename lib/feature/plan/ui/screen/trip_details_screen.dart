import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/plan/logic/controller/trip_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripDetailsController(tripId));

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CustomBackButton(),
          title: Obx(() => Text(
            controller.trip.value?.title ?? 'Trip Details',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          final trip = controller.trip.value;
          if (trip == null) {
            return const Center(child: Text('Trip not found', style: TextStyle(color: Colors.white)));
          }

          return CustomScrollView(
            slivers: [
              // Trip Header Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoChip(Icons.location_on, trip.destination ?? 'No destination'),
                      const SizedBox(height: 12),
                      _buildInfoChip(Icons.calendar_today, _formatDateRange(trip.startDate, trip.endDate)),
                    ],
                  ),
                ),
              ),

              // Itinerary Days
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final day = trip.days![index];
                    return _buildDaySection(day);
                  },
                  childCount: trip.days?.length ?? 0,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDaySection(dynamic day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Day ${day.dayNumber}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                day.notes ?? 'Daily Itinerary',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        if (day.activities != null)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: day.activities!.length,
            itemBuilder: (context, idx) {
              final activity = day.activities![idx];
              return _buildActivityCard(activity);
            },
          ),
      ],
    );
  }

  Widget _buildActivityCard(dynamic activity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity.time ?? '--:--',
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
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
}
