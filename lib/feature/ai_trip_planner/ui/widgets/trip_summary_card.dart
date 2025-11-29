import 'package:flutter/material.dart';

class TripSummaryCard extends StatelessWidget {
  final int totalDays;
  final String budget;

  const TripSummaryCard({
    Key? key,
    required this.totalDays,
    required this.budget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced margin
      padding: const EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepOrange, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            Icons.calendar_today,
            '$totalDays Days',
            'Duration',
          ),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)), // Reduced height
          _buildSummaryItem(
            Icons.hotel,
            '${totalDays - 1} Nights',
            'Accommodation',
          ),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)), // Reduced height
          _buildSummaryItem(
            Icons.account_balance_wallet,
            budget,
            'Budget',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20), // Reduced icon size
        const SizedBox(height: 4), // Reduced spacing
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14, // Reduced font size
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10), // Reduced font size
        ),
      ],
    );
  }
}
