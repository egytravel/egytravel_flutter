import 'dart:ui';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletTripCard extends StatelessWidget {
  final TripModel trip;
  final double totalExpenses;
  final VoidCallback onTap;

  const WalletTripCard({
    super.key,
    required this.trip,
    required this.totalExpenses,
    required this.onTap,
  });

  String get _dateRange {
    if (trip.startDate == null || trip.endDate == null) return 'Dates TBD';
    try {
      final s = DateTime.parse(trip.startDate!);
      final e = DateTime.parse(trip.endDate!);
      return '${DateFormat('MMM d').format(s)} - ${DateFormat('MMM d').format(e)}';
    } catch (_) {
      return 'Dates TBD';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  // Trip icon (TripModel has no imageUrl)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A5F), Color(0xFF0A1628)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: Colors.white54,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Trip Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.destination ?? trip.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dateRange,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Total Expenses
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: totalExpenses > 0
                                ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            totalExpenses > 0
                                ? 'EGP ${totalExpenses.toStringAsFixed(0)}'
                                : 'No expenses yet',
                            style: TextStyle(
                              color: totalExpenses > 0
                                  ? const Color(0xFF818CF8)
                                  : Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
