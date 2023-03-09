import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:cleversell_booking/core/controller/splash_controller.dart';
import 'package:cleversell_booking/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'core/bindings/application_binding.dart';
import 'core/lang/MainLocale.dart';
import 'core/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return OverlaySupport.global(
        child: GetMaterialApp(
            title: 'Cleversell Booking',
            initialBinding: ApplicationBinding(),
            color: primary,
            debugShowCheckedModeBanner: false,
            translations: MainLocale(),
            fallbackLocale: const Locale('en', 'EN'),
            locale: const Locale('en', 'EN'),
            theme: ThemeData(
              fontFamily: "BarlowCondensed",
              unselectedWidgetColor: Colors.green,
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              dialogBackgroundColor: secondary,
            ),
            home: SplashScreen(SplashController()),
            getPages: routes));
  }
}
