import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/data/model/room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/urls.dart';
import '../data/model/check_in.dart';
import '../data/repository/cash_in_repository.dart';

class CashInController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  DateTime endDate = DateTime.now();
  String? branchId = '';
  SharedPreferences? prefs;
  List<CheckInModel> allCheckIns = [];
  bool loading = false;
  bool printerConnected = false;

  double paymentsNum = 0;
  double totalPayment = 0;
  double totalCashPayment = 0;
  double totalCashRefunds = 0;
  double netCashPayments = 0;
  double totalVisaPayment = 0;
  double totalVisaRefunds = 0;
  double netVisaPayments = 0;

  final CashInRepository _cashInRepository;

  CashInController(this._cashInRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    branchId = prefs?.getString("branch");
    startDate = now.subtract(const Duration(days: 10));
    await checkPrinter();

    super.onInit();
  }

  checkPrinter() async {
    String? printerIp = prefs?.get("printer_ip").toString();
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    // if (printerIp != null && printerIp != '') {
    // final PosPrintResult res = await printer.connect(printerIp, port: 9100);
    final PosPrintResult res = await printer.connect('192.168.1.9', port: 9100);

    if (res == PosPrintResult.success) {
      printerConnected = true;
    }
    // }

    printerConnected = false;
  }

  printInvoice() async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    String? printerIp = prefs?.get("printer_ip").toString();

    // String? printerIp = '192.168.1.9';
    // final PosPrintResult res = await printer.connect(printerIp, port: 9100);
    final PosPrintResult res = await printer
        .connect('${printerIp}', port: 9100)
        .timeout(const Duration(seconds: 3));
    print('res');
    print(res.msg);
    if (res == PosPrintResult.success) {
      await printReceipt(printer);
      printer.disconnect();
    }

    print('Print result: ${res.msg}');
  }

  Future<void> printReceipt(NetworkPrinter printer) async {
    var serial = DateTime.now()
        .toUtc()
        .millisecondsSinceEpoch
        .toString()
        .substring(5, 12);
    print(serial);

    var request = await Permission.storage.request();

    printer.text('#OR0169917',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));

    printer.row([
      PosColumn(
        text: 'From',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: 'To',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.row([
      PosColumn(
        text: startDate.toString(),
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: endDate.toString(),
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('=====================================',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Total Cash Payments',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$totalCashPayment',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Total Cash Refunds',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$totalCashRefunds',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Total Visa Payments',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$totalVisaPayment',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Total Visa Refunds',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$totalVisaRefunds',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Net Visa Payments',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$netVisaPayments',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('=====================================',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('TOTAL NO. OF PAYMENTS',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('$paymentsNum',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('TOTAL PAYMENTS',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('$totalPayment',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));

    printer.feed(2);
    printer.cut();
  }

  nextDate() {
    endDate = endDate.add(const Duration(days: 1));
    update();
  }

  prevDate() {
    startDate = startDate.subtract(const Duration(days: 1));
    update();
  }

  pickDateRange(DateTimeRange? picked) {
    startDate = picked?.start as DateTime;
    endDate = picked?.end as DateTime;
    update();
  }

  calculatePayments(DateTimeRange? picked) async {
    loading = true;
    startDate = picked?.start as DateTime;
    endDate = picked?.end as DateTime;
    update();
    await getBookings();
    loading = false;
    update();
  }

  resetNumbers() {
    paymentsNum = 0;
    totalPayment = 0;
    totalCashPayment = 0;
    totalCashRefunds = 0;
    netCashPayments = 0;
    totalVisaPayment = 0;
    totalVisaRefunds = 0;
    netVisaPayments = 0;
    update();
  }

  getBookings() async {
    resetNumbers();
    var endHour = now.hour;
    var endMin = now.minute;
    var endDay = endDate.day;
    var startDateMoment =
        DateTime(startDate.year, startDate.month, startDate.day, 15, 00)
            .add(const Duration(hours: 3))
            .toUtc()
            .millisecondsSinceEpoch
            .toString();
    print('diff');
    print(DateTime(endDate.year, endDate.month, endDate.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays);
    var endDiff = DateTime(endDate.year, endDate.month, endDate.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (endDiff != 0) {
      endHour = 03;
      endMin = 00;
      endDay = endDate.day + 1;
    }

    var endDateMoment =
        DateTime(endDate.year, endDate.month, endDay, endHour, endMin)
            .add(const Duration(hours: 3))
            .toUtc()
            .millisecondsSinceEpoch
            .toString();

    var filter =
        '$checkInsLisPath?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
    var response = await _cashInRepository.getCheckInsByDate(filter);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var checkInList = body?["rows"];

      allCheckIns = checkInList
          ?.map<CheckInModel>((u) => CheckInModel.fromJson(u))
          ?.toList();

      // print("allCheckIns.length");
      // print(allCheckIns.length);

      for (var booking in allCheckIns) {
        var amount = double.parse(booking.paid!);
        print("amount");
        print(amount);
        print(booking.payments);
        totalPayment = amount + totalPayment;
        // print("booking.payments");
        // print(booking.payments!.length);
        if (amount > 0) {
          if (booking.payments != null) {
            // bool hasRefund = booking.payments!.map((e) => e['type'] == 'cash_refund' || e['type'] == 'visa_refund') as bool;
            for (var payment in booking.payments!) {
              if (payment['method'] == 'cash') {
                if (payment['amount'] != null) {
                  totalCashPayment =
                      double.parse(payment['amount']) + totalCashPayment;
                  paymentsNum++;
                }
              }
              if (payment['method'] == 'visa') {
                if (payment['amount'] != null) {
                  totalVisaPayment =
                      double.parse(payment['amount']) + totalVisaPayment;
                  paymentsNum++;
                }
              }

              if (payment['method'] == 'cash_refund') {
                if (payment['amount'] != null) {
                  totalCashRefunds =
                      double.parse(payment['amount']) + totalCashRefunds;
                  paymentsNum++;
                }
              }
              if (payment['method'] == 'visa_refund') {
                if (payment['amount'] != null) {
                  totalVisaPayment =
                      double.parse(payment['amount']) + totalVisaRefunds;
                  paymentsNum++;
                }
              }
            }
          }
        }
      }
      netCashPayments = totalCashPayment - totalCashRefunds;
      netVisaPayments = totalVisaPayment - totalCashRefunds;
      update();
    }
  }

  refreshPayments() async {
    print('called');
    var picked = DateTimeRange(
      end: endDate,
      start: startDate,
    );
    print('picked');
    print(picked);
    await calculatePayments(picked);
  }
}
