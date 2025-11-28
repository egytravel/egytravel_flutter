import 'package:egytravel_app/feature/ai_chat/logic/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial welcome message
    messages.add(
      ChatMessage(
        text: "Hello! I'm your AI Travel Assistant. How can I help you plan your trip to Egypt today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    messages.add(
      ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    
    messages.add(
      ChatMessage(
        text: "That sounds exciting! I can definitely help you with that. Could you tell me more about your preferences?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    isLoading.value = false;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
