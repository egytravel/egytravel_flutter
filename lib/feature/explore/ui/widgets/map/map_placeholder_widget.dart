import 'package:flutter/material.dart';

class MapPlaceholderWidget extends StatelessWidget {
  const MapPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.05),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_rounded, size: 60, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              "Map Integration Coming Soon",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
