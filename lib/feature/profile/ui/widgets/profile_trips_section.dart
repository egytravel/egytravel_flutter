import 'package:egytravel_app/core/models/trip_model.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_trip_card.dart';
import 'package:flutter/material.dart';

class ProfileTripsSection extends StatelessWidget {
  final List<Trip> trips;
  final Function(Trip) onTripTap;

  const ProfileTripsSection({
    super.key,
    required this.trips,
    required this.onTripTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(
                Icons.luggage_rounded,
                size: 20,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'My Trips',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (trips.isNotEmpty)
                Text(
                  '${trips.length} ${trips.length == 1 ? 'trip' : 'trips'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Trips List or Empty State
        if (trips.isEmpty)
          _buildEmptyState()
        else
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return ProfileTripCard(
                  trip: trips[index],
                  onTap: () => onTripTap(trips[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            Icon(
              Icons.explore_outlined,
              size: 48,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Not have trip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add first trip and start your journey!',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
