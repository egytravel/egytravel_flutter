import 'package:flutter/material.dart';

class PapyrusBackground extends StatelessWidget {
  const PapyrusBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF5E6D3), // Light papyrus color
            const Color(0xFFE8D5B7), // Darker papyrus color
            const Color(0xFFF0E68C).withOpacity(0.3), // Khaki with opacity
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          // Add subtle texture pattern
          image: DecorationImage(
            image: _createTexturePattern(),
            repeat: ImageRepeat.repeat,
            opacity: 0.1,
          ),
        ),
      ),
    );
  }

  ImageProvider _createTexturePattern() {
    // In a real app, you would use an actual papyrus texture image
    // For now, we'll use a simple pattern
    return const AssetImage('assets/images/papyrus_texture.png');
  }
}

// Alternative simple background without image dependency
class SimplePapyrusBackground extends StatelessWidget {
  const SimplePapyrusBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF5E6D3), // Light papyrus
            const Color(0xFFE8D5B7), // Medium papyrus
            const Color(0xFFDEB887), // Burlywood
            const Color(0xFFF0E68C).withOpacity(0.8), // Khaki
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          // Add some noise/grain effect
          color: Colors.brown.withOpacity(0.02),
        ),
      ),
    );
  }
}