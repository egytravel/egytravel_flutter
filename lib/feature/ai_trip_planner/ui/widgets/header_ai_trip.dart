import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onClose;
  const Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,

            ),
            child: const Icon(Icons.close, size: 24, color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            children: [
              Text("plane  a new trip",
           style:   TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),),
               SizedBox(height: 16),
              Center(
                child: Text("Build an itinerary and map out your upcoming travel plans",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white60,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 8)],
                ),),
              ),
            ],
          )
        ),
      ],
    );
  }
}
