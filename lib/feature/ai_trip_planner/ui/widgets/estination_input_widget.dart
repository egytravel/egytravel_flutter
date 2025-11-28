import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/glass_container_widget.dart';
import 'package:flutter/material.dart';

class DestinationInput extends StatelessWidget {
  final TextEditingController controller;
  const DestinationInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: 'Where to?',
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          hintText: 'e.g., Cairo, Luxor, Alexandria',
          hintStyle: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.location_on, color: Colors.orange, size: 22),
        ),
      ),
    );
  }
}
