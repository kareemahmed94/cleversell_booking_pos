import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

Widget newBtn(DashboardController controller, context, bool isCheckOut) {
  return TextButton(
    // onPressed: () => isCheckOut ? controller.printInvoice() : () => {},
    // onPressed: () => isCheckOut ? controller.initNewCheckIn() : () => {},
    onPressed: () => controller.initNewCheckIn(context),
    child: Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.add,
              color: isCheckOut ? secondaryDim : highlight,
              size: 30.0,
            ),
            const SizedBox(width: 10),
            Container(
              width: 60,
              child: Text("NEW",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: isCheckOut ? secondaryDim : highlight)),
            )
          ],
        ),
        SizedBox(
          width: 120,
          child: Divider(
            color: isCheckOut ? secondary : highlight,
          ),
        )
      ],
    ),
  );
}

Widget printBtn(DashboardController controller, context) {
  return TextButton(
      onPressed: () => controller.printInvoice(),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.print,
                color: secondaryDim,
                size: 30.0,
              ),
              const SizedBox(width: 10),
              Container(
                width: 80,
                child: const Text("PRINT",
                    style: TextStyle(fontSize: 25.0, color: secondaryDim)),
              )
            ],
          ),
          const SizedBox(
            width: 120,
            child: Divider(
              color: secondary,
            ),
          )
        ],
      ));
}

Widget scanBtn(DashboardController controller, context) {
  return TextButton(
      onPressed: () => controller.showScanDialog(context),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.qr_code_scanner,
                color: secondaryDim,
                size: 30.0,
              ),
              const SizedBox(width: 10),
              Container(
                width: 80,
                child: const Text("SCAN",
                    style: TextStyle(fontSize: 25.0, color: secondaryDim)),
              )
            ],
          ),
          const SizedBox(
            width: 120,
            child: Divider(
              color: secondary,
            ),
          )
        ],
      ));
}

Widget visaBtn(DashboardController controller, context) {
  return TextButton(
    onPressed: () => controller.confirmSubmitCheckIn('visa', context),
    child: Container(
      // width: 80,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: controller.checkCheckInBtn('visa') ? highlight : surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.credit_card,
            color: controller.checkCheckInBtn('visa') ? surface : secondaryDim,
            size: 30.0,
          ),
          Text("VISA",
              style: TextStyle(
                  fontSize: 20.0,
                  color: controller.checkCheckInBtn('visa')
                      ? surface
                      : secondaryDim)),
        ],
      ),
    ),
  );
}

Widget cashBtn(DashboardController controller, context) {
  return TextButton(
    onPressed: () => controller.confirmSubmitCheckIn('cash', context),
    child: Container(
      // width: 80,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: controller.checkCheckInBtn('cash') ? highlight : surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.money_outlined,
            color: controller.checkCheckInBtn('cash') ? surface : secondaryDim,
            size: 30.0,
          ),
          Text("CASH",
              style: TextStyle(
                  fontSize: 20.0,
                  color: controller.checkCheckInBtn('cash')
                      ? surface
                      : secondaryDim)),
        ],
      ),
    ),
  );
}

Widget paymentBtn(DashboardController controller, context) {
  return TextButton(
    onPressed: () => controller.showPaymentInfo(),
    child: Container(
      width: 300,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: highlight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset.zero,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt,
            color: surface,
            size: 40.0,
          ),
          SizedBox(width: 10,),
          Text("PAYMENT",textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0, color: surface)),
        ],
      ),
    ),
  );
}
