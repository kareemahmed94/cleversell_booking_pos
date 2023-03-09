import 'dart:convert';

import 'package:cleversell_booking/core/data/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../data/repository/company_repository.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class CompanyAuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String status = 'loading';
  SharedPreferences? prefs;
  final FocusNode focusNode = FocusNode();
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  final loginFormKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final pin = TextEditingController();
  final CompanyRepository _companyRepository;
  AnimationController? animationController;

  var booking = {
    "_id": "1535778000187",
    "_rev": "8-d85c8a8dc3b549e2dbb5c00134ff2fa1",
    "user": {"phone": "01222453301", "name": "Seif Mohsen"},
    "branch": {
      "name": "Point90",
      "_id": "a3be8760-9b03-11e8-ab05-3f7e17042767"
    },
    "time": "07:00:00",
    "date": "2018-09-01",
    "quantity": 1,
    "product": {
      "_id": "c81da550-967b-11e8-819b-e355739b6c97",
      "_rev": "2-f4fd078566270763ce6460c17a8b33c6",
      "name": "I-Zone",
      "branch": {
        "name": "Point90",
        "_id": "a3be8760-9b03-11e8-ab05-3f7e17042767"
      },
      "price": "80",
      "adds": [],
      "room": [
        {"name": "I-Zone", "_id": "4183a2e0-9e48-11e8-8331-0350a3b549cf"}
      ],
      "active": true
    },
    "addOns": [],
    "room": [
      {"name": "I-Zone", "_id": "4183a2e0-9e48-11e8-8331-0350a3b549cf"}
    ],
    "promo": {"_id": "", "code": null, "value": "0"},
    "paid": [
      {
        "amount": 80,
        "method": "cash",
        "Date": "1535760000",
        "serial": "IZ0000005"
      }
    ],
    "staff": {
      "name": "Omar Younis",
      "_id": "965fa2e0-adc6-11e8-ba49-dd6a11e8ef65"
    },
    "status": 1
  };

  // const PaperSize paper = PaperSize.mm80;
  // final profile = await CapabilityProfile.load();
  // final printer = NetworkPrinter(paper, profile);
  //
  // final PosPrintResult res = await printer.connect('192.168.0.123', port: 9100);

  final PaperSize paper = PaperSize.mm80;

  static const platform =
      MethodChannel('com.cleversell.qpix.cleversell_booking');

  String value = '';

  var found = 0;

  CompanyAuthController(this._companyRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {});
    animationController?.repeat(reverse: true);

    super.onInit();
  }

  @override
  void onClose() {
    animationController?.dispose();
    super.dispose();
  }

  void testPrinter() async {
    // try {
    //   var data = {'invoice': booking, 'ip': '192.16.1.11'};
    //   value = await platform.invokeMethod("printInvoice", data);
    // } catch (e) {
    //   print(e);
    // }

    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect('192.168.1.11', port: 9100);

    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();
    }

    print('Print result: ${res.msg}');
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }

  void login(context) async {
    loading = true;
    if (formKey.currentState!.validate()) {
      var response =
          await _companyRepository.companyLogin(username.text, pin.text);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        prefs?.setString("token", body?["token"]);
        prefs?.setString("company", jsonEncode(body?["company"]));
        Get.toNamed(branchAuthRoute);
      } else {
        Get.snackbar("Login", "Please enter valid credentials",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }

    loading = false;
    update();
  }
}
