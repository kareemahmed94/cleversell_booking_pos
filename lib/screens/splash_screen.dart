import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:cleversell_booking/ui/widgets/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller;

  const SplashScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: controller,
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (_) {
          return _body(context);
        });
  }

  Widget _body(context) {
    return Scaffold(
        backgroundColor: primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(bottom: 50),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo-circle.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Loader(),
            ],
          )
        ));
  }
}
