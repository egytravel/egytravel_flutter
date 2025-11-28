import 'package:egytravel_app/feature/ai_chat/ui/screens/ai_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9C27B0), // Purple
            Color(0xFFFF4081), // Pink
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(() => const AiChatScreen());
          },
          borderRadius: BorderRadius.circular(28),
          child: const Center(
            child: Icon(
              Icons.auto_fix_high,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
