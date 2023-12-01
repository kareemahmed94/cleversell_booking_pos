import 'dart:convert';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../data/model/branch.dart';
import '../data/repository/branch_repository.dart';

class SettingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SettingsController(this._branchRepository);

  SharedPreferences? prefs;
  AnimationController? animationController;
  final BranchRepository _branchRepository;

  List<BranchModel> branches = [];
  var selectedBranch;
  String selectedEnv = "dev";
  final serverIp = TextEditingController();
  final printerIp = TextEditingController();

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {});
    animationController?.repeat(reverse: true);
    prefs?.setString("env", "dev");

    getBranches();

    super.onInit();
  }

  @override
  void onClose() {
    animationController?.dispose();
    super.dispose();
  }

  getBranches() async {
    var response = await _branchRepository.getBranches();
    if (response.statusCode == 200 ) {
      var body = jsonDecode(response.body);
      var branchesList = body?["rows"];
      List<BranchModel> branchesData = branchesList?.map<BranchModel>((u) => BranchModel.fromJson(u))
          ?.toList();
      branches = branchesData;
      selectedBranch = branches[0].id;
      update();
    }
  }

  void selectBranch(branchId) {
    selectedBranch = branchId;
    update();
  }

  void selectEnv(env) async {
    if (env == "DEVELOPMENT") {
      selectedEnv = "dev";
      prefs?.setString("env", "dev");
    } else if (env == "PRODUCTION") {
      selectedEnv = "prod";
      prefs?.setString("env", "prod");
    } else if (env == "CUSTOM") {
      selectedEnv = "custom";
      prefs?.setString("env", "custom");
    }
    update();
    await getBranches();
  }

  void logout() {
    prefs?.remove('token');
    prefs?.remove('company');
    prefs?.remove('server_ip');
    Get.toNamed(companyAuthRoute);
  }

  void login() async {
    final printerConnection = await tryPrinterConnection(printerIp.text);
    if (printerConnection) {
      prefs?.setString('printer_conn', 'true');
    }
    prefs?.setString('branch', selectedBranch);
    prefs?.setString('server_ip', serverIp.text);
    prefs?.setString('printer_ip', printerIp.text);
    Get.toNamed(dashboardRoute);
  }

  Future<bool> tryPrinterConnection(printerIP) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(printerIP, port: 9100);

    if (res == PosPrintResult.success) {
      return true;
    }
    return false;
  }
}
