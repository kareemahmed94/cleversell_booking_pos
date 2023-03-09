import 'dart:convert';

import '../../core/data/model/staff.dart';
import '../../core/data/repository/staff_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';

class StaffAuthController extends GetxController {
  StaffAuthController(this._staffRepository);

  FocusNode focusNode = FocusNode();

  final StaffRepository _staffRepository;

  String status = 'loading';
  String? savedStaffId;
  SharedPreferences? prefs;
  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final scrollDuration = const Duration(milliseconds: 500);

  final loginFormKey = GlobalKey<FormState>();
  final password = TextEditingController();

  int prevIndex = 0;
  int nextIndex = 1;

  List<dynamic> staff = [];
  late StaffModel selectedStaff;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    var savedStaff = prefs?.getString("staff");
    if (savedStaff != null) {
      savedStaffId = jsonDecode(savedStaff)["id"];
    }

    await getStaff();
    await updateSelectedStaff();
    super.onInit();
  }

  login() async {
    if (selectedStaff == null) {
      Get.snackbar("Login", "Please Select User",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (password.text == '') {
      Get.snackbar("Login", "Please enter password",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    var branchId = prefs?.getString("branch");
    String passwordValue = password.text;
    String? staffId = selectedStaff.staffId;
    var response =
        await _staffRepository.login(branchId, staffId, passwordValue);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body["rows"]?.length > 0) {
        prefs?.setString("staff", jsonEncode(selectedStaff));
        Get.toNamed(dashboardRoute);
      } else {
        Get.snackbar("Login", "Wrong Password",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }
  }

  getStaff() async {
    var branch = prefs?.getString("branch");
    var response = await _staffRepository.getStaff();
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var staffList = body?["rows"];
      staffList = staffList?.where((element) =>
          element?["value"]?["isDeleted"] == null &&
          element["value"]?["branch"]?["_id"] == branch);
      staff = staffList.map<dynamic>((u) {
        return StaffModel.fromJson(u);
      })?.toList();
      update();
    }
  }
  updateSelectedStaff() {
    if (savedStaffId != null) {
      focusNode.requestFocus();
      selectedStaff = staff.firstWhere((element) => element.id == savedStaffId);
      // var index = staff.indexWhere((element) => element.id == savedStaffId);
      // scrollController.scrollTo(
      //     index: 0,
      //     duration: scrollDuration,
      //     curve: Curves.easeInOutCubic,
      //     alignment: 0);
      // scrollTo(index-3);

    } else {
      selectedStaff = staff[0];
    }
  }

  void next() {
    scrollTo(nextIndex);
    nextIndex++;
    prevIndex++;
    update();
  }

  void prev() {
    if (prevIndex != 0) {
      scrollTo(prevIndex);
      if (nextIndex != 1 || nextIndex != 2) {
        nextIndex--;
      }
      prevIndex--;
      update();
    }
  }

  void scrollTo(index) => scrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: 0);

  void selectStaff(staff) {
    focusNode.requestFocus();
    selectedStaff = staff;
    update();
  }
}
