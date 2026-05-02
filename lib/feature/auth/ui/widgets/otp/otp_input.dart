import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
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
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: 45,
      height: 55,
      borderRadius: 12,
      padding: EdgeInsets.zero,
      borderColor: _isFocused ? AppColor.primary : Colors.white.withOpacity(0.2),
      color: _isFocused ? AppColor.primary.withOpacity(0.1) : Colors.white.withOpacity(0.05),
      child: Center(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autoFocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.length == 1 && !widget.isLast) {
              widget.nextFocusNode?.requestFocus();
            }
          },
        ),
      ),
    );
  }
}
