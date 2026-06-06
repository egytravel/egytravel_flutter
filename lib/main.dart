import 'package:egytravel_app/core/network/network_controller.dart';
import 'package:egytravel_app/core/routes/app_pages.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:egytravel_app/core/widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

import 'package:feedback/feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();

  // Register the NetworkController as a permanent singleton so it lives
  // for the full app lifecycle and is accessible from anywhere via Get.find().
  Get.put(NetworkController(), permanent: true);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const BetterFeedback(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EgyTravel',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primaryColor,
          brightness: Brightness.dark,
          primary: AppColor.primaryColor,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.appPages(),
      // ── Global No-Internet Overlay ─────────────────────────────────────────
      // The builder wraps every page produced by the router. When the device
      // loses connectivity the NoInternetWidget slides in on top; when it
      // reconnects the normal page reappears — with zero per-screen changes.
      builder: (context, child) {
        return Obx(() {
          if (!networkController.isConnected.value) {
            return const NoInternetWidget();
          }
          return child ?? const SizedBox.shrink();
        });
      },
    );
  }
}

