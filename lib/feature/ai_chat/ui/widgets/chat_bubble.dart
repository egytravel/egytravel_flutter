import 'package:egytravel_app/feature/ai_chat/logic/models/chat_message.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(12),
              borderRadius: 16,
              color: isUser
                  ? const Color(0xFF6C5CE7).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              borderColor: isUser
                  ? const Color(0xFF6C5CE7).withOpacity(0.5)
                  : Colors.white.withOpacity(0.2),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
