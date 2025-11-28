import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime? date;

  const DateBox({required this.icon, required this.label, this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: 8),
        Text(
          date != null ? DateFormat('MMM dd').format(date!) : label,
          style: TextStyle(
            fontSize: 15,
            color: date != null ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
