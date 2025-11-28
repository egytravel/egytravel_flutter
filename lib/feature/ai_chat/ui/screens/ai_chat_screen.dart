import 'package:egytravel_app/feature/ai_chat/logic/controller/ai_chat_controller.dart';
import 'package:egytravel_app/feature/ai_chat/ui/widgets/chat_bubble.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiChatController());

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'AI Travel Assistant',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length + (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
                        ),
                      );
                    }
                    return ChatBubble(message: controller.messages[index]);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GlassContainer(
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controller.messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: controller.sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C5CE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
