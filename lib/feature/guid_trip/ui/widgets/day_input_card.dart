import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayInputCard extends StatelessWidget {
  final GuideDayModel day;

  const DayInputCard({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Day ${day.dayNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => IconButton(
              icon: Icon(
                day.isExpanded.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              onPressed: () => day.isExpanded.toggle(),
            )),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => Visibility(
          visible: day.isExpanded.value,
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTextField(
                  label: 'Place',
                  icon: Icons.place,
                  onChanged: (value) => day.place = value,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Address',
                  icon: Icons.map,
                  onChanged: (value) => day.address = value,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Notes',
                  icon: Icons.note,
                  maxLines: 3,
                  onChanged: (value) => day.notes = value,
                ),
              ],
            ),
          ),
        )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.orange),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}
