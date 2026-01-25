import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/data_box.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/glass_container_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/show_data_picker.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime, DateTime) onDateSelected;

  const DateSelector({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (context) => DatePickerWidget(
          onSave: (start, end) {
            if (start != null && end != null) {
              onDateSelected(start, end);
            }
          },
        ),
      ),
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dates (optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DateBox(
                      icon: Icons.calendar_today,
                      label: 'Start date',
                      date: startDate,
                    ),
                  ),
                  Expanded(
                    child: DateBox(
                      icon: Icons.calendar_today,
                      label: 'End date',
                      date: endDate,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}