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
    return (bookingUrl != null && bookingUrl!.isNotEmpty)
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          )
        : Container();
  }
}
