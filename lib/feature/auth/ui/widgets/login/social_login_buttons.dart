import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            imageName: 'assets/image/logo_google-.png',
            label: 'Google',
            sizeImage: 28,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SocialButton(
            imageName: 'assets/image/facebook.png',
            sizeImage: 24,
            label: 'Facebook',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String imageName;
  final String label;
  final double sizeImage;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.imageName,
    required this.label,
    required this.sizeImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1), // Lighter border
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white.withOpacity(0.05), // Slight background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageName, width: sizeImage),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white, // Changed to white
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
