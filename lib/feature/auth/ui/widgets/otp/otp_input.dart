import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final bool isLast;
  final bool autoFocus;

  const OtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.isLast = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: 60,
      height: 70,
      borderRadius: 12,
      padding: EdgeInsets.zero,
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autoFocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.length == 1 && !isLast) {
              nextFocusNode?.requestFocus();
            }
            if (value.isEmpty && focusNode.canRequestFocus) {
               // Handle backspace if needed, usually handled by previous node requesting focus
               // but standard behavior is often enough.
               // For better backspace handling, we might need a raw keyboard listener,
               // but keeping it simple for now as per request.
            }
          },
        ),
      ),
    );
  }
}
