import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileTripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;
  final int index;

  const ProfileTripCard({
    super.key,
    required this.trip,
    required this.onTap,
    required this.index,
  });

  Color _getCardColor(int index) {
    final List<Color> darkColors = [
      const Color(0xFF1A4B8F), // royalBlue
      const Color.fromARGB(255, 101, 32, 88), // midnightBlueDark
      const Color.fromARGB(255, 116, 36, 36), // deepNavy
    ];
    return darkColors[index % darkColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cardPrimaryColor = _getCardColor(index);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 180,
        margin: const EdgeInsets.only(right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardPrimaryColor,
                      const Color(0xFF0A1628), // Always fade to very dark
                    ],
                  ),
                ),
              ),
              // Decorative icon
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.flight_takeoff_rounded,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              // Content
              Container(
                padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                trip.status,
                              ).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _statusIcon(trip.status),
                                  color: Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _capitalize(trip.status),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Destination
                      Text(
                        trip.destination ?? trip.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Date range + duration
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDateRange(trip.startDate, trip.endDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (trip.durationInDays > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '• ${trip.durationInDays}d',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planning':
        return const Color(0xFF6366F1);
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'completed':
        return const Color(0xFF3B82F6);
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'planning':
        return Icons.edit_outlined;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.flag_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatDateRange(String? start, String? end) {
    if (start == null || end == null) return 'Dates TBD';
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      return '${DateFormat('MMM d').format(s)} - ${DateFormat('MMM d').format(e)}';
    } catch (_) {
      return 'Dates TBD';
    }
  }
}
