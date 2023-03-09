import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SharedPreferences? prefs;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(milliseconds: 500), () async {
      await _checkAppStatus();
    });
    super.onInit();
  }

  _checkAppStatus() async {
    var company = prefs?.get("company");
    var branch = prefs?.get("branch");
    var staff = prefs?.get("staff");

    if (company == null) {
      Get.toNamed(companyAuthRoute);
    }
    if (company != null && branch == null) {
      Get.toNamed(branchAuthRoute);
    }
    if (company != null && branch != null && staff == null) {
      Get.toNamed(staffAuthRoute);
    }
    if (company != null && branch != null && staff != null) {
      Get.toNamed(staffAuthRoute);
    }
  }
}
