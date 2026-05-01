import 'package:egytravel_app/core/routes/app_pages.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

import 'package:feedback/feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EgyTravel',
      // Device Preview Configuration
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
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
    );
  }
}
