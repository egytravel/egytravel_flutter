import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onClose;
  const Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomBackButton(onPressed: onClose),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            children: [
              Text(
                "plane  a new trip",
                style: TextStyle(
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
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  "Build an itinerary and map out your upcoming travel plans",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white60,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
