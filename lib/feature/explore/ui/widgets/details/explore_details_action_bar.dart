import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/custom_button.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class ExploreDetailsActionBar extends StatelessWidget {
  final String price;
  final String? bookingUrl;

  const ExploreDetailsActionBar({
    super.key,
    required this.price,
    this.bookingUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppColor.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (bookingUrl != null && bookingUrl!.isNotEmpty)
                Expanded(
                  child: CustomButton(
                    text: "Book Now",
                    backgroundColor: AppColor.primary,
                    textColor: Colors.white,
                    onPressed: () async {
                      try {
                        final url = Uri.parse(bookingUrl!);
                        await launchUrl(url, mode: LaunchMode.inAppBrowserView);
                      } catch (e) {
                        showError('Could not launch booking site');
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
