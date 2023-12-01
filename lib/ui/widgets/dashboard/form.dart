import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import 'buttons.dart';
import 'items.dart';

Widget formItems(DashboardController controller, context) {
  return Column(
    children: [
      controller.checkIn != null
          ? Column(
              children: [
                invoiceRow(controller, context),
                typeRow(controller, context),
                roomSelectRow(controller, context),
                selectDateTimeRow(controller, context),
              ],
            )
          : Column(
              children: [
                controller.bookingType == 'product'
                    ? Center()
                    : roomSelectRow(controller, context),
                // DATE TIME
                controller.bookingType == 'product'
                    ? Center()
                    : controller.bookingType == 'reservation'
                        ? Column(
                            children: [
                              selectDateRow(controller, context),
                            ],
                          )
                        : selectTimeRow(controller, context),
              ],
            ),
      controller.bookingType == 'product' ? Center() : divider(context),
      controller.bookingType != 'product'
          ? Column(
              children: [
                selectProductsRow(controller, context),
                divider(context),
              ],
            )
          : const Center(),
      selectCustomerRow(controller, context),
      divider(context),
      controller.selectedCustomer != null && controller.bookingType != 'product'
          ? DOCustomerNameRow(controller, context)
          : const Center(),
      controller.selectedCustomer != null && controller.bookingType != 'product'
          ? divider(context)
          : const Center(),
      controller.selectedCustomer != null && controller.bookingType != 'product'
          ? DOCustomerPhoneRow(controller, context)
          : const Center(),
      controller.selectedCustomer != null && controller.bookingType != 'product'
          ? divider(context)
          : const Center(),
      controller.selectedCustomer != null && controller.bookingType != 'product' &&
              controller.selectedCustomer!.children!.isNotEmpty
          ? childrenRow(controller, context)
          : Center(),
      controller.selectedCustomer != null && controller.bookingType != 'product' &&
              controller.selectedCustomer!.children!.isNotEmpty
          ? divider(context)
          : Center(),
      addonProductRow(controller, context),
      divider(context),
      promoCodeRow(controller, context),
      divider(context),
      controller.bookingType != 'product'
          ? fullPaymentCheckRow(controller, context)
          : Center(),
      controller.fullPayment
          ? const Center()
          : depositInputRow(controller, context),
      controller.bookingType != 'product' ? divider(context) : Center(),
    ],
  );
}

Widget form(DashboardController controller, context) {
  return Container(
    // padding: const EdgeInsets.only(top: 10),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              width: MediaQuery.of(context).size.width / 3.4,
              height: MediaQuery.of(context).size.height / 2,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        controller.checkIn != null
                            ? printBtn(controller, context)
                            : scanBtn(controller, context),
                        newBtn(controller, context, controller.checkIn != null),
                      ],
                    ),
                  ),
                  bookingTypes(controller, context),
                  Container(
                      // padding: const EdgeInsets.only(top: 10.0),
                      height: 220,
                      child: SingleChildScrollView(
                          controller: controller.formScrollController,
                          child: formItems(controller, context))),
                ],
              )),
        ),
        Container(
          // width: MediaQuery.of(context).size.width / 3.4,
          padding: const EdgeInsets.all(10.0),
          // height: 150.0,
          decoration: const BoxDecoration(
            color: background,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      controller.checkIn != null &&
                              controller.checkIn!.checkedIn &&
                              controller.checkIn!.type != 'product'
                          ? Container(
                              width: MediaQuery.of(context).size.width / 3.7,
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                  color: error,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Time Spent',
                                        style: TextStyle(
                                            color: primary, fontSize: 22.0),
                                      ),
                                      const SizedBox(width: 60),
                                      Text(
                                        controller.timeSpentString,
                                        style: const TextStyle(
                                            color: primary, fontSize: 22.0),
                                      ),
                                    ],
                                  ),
                                  !controller.checkIn!.checkedOut ? Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Paid',
                                        style: TextStyle(
                                            color: primary, fontSize: 22.0),
                                      ),
                                      const SizedBox(width: 115),
                                      Text(
                                        '${controller.checkIn?.paid}',
                                        style: const TextStyle(
                                            color: primary, fontSize: 22.0),
                                      ),
                                    ],
                                  ) : Center(),
                                  controller.moneyDiff != '' && !controller.checkIn!.checkedOut
                                      ? Row(
                                          children: [
                                            const SizedBox(width: 20),
                                            const Text(
                                              'Remaining',
                                              style: TextStyle(
                                                  color: primary,
                                                  fontSize: 22.0),
                                            ),
                                            const SizedBox(width: 70),
                                            Text(
                                              controller.moneyDiff,
                                              style: const TextStyle(
                                                  color: primary,
                                                  fontSize: 22.0),
                                            ),
                                          ],
                                        )
                                      : Center(),
                                ],
                              ),
                            )
                          : Center(),
                      controller.checkIn != null &&
                              !controller.checkIn!.checkedIn &&
                              controller.checkIn?.type == 'reservation' &&
                              (controller.checkIn?.paid != null ||
                                  controller.checkIn?.paid != '')
                          ? Container(
                              width: MediaQuery.of(context).size.width / 3.7,
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                  color: error,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Paid',
                                        style: TextStyle(
                                            color: primary, fontSize: 22.0),
                                      ),
                                      const SizedBox(width: 115),
                                      Text(
                                        '${controller.checkIn?.paid}',
                                        style: const TextStyle(
                                            color: primary, fontSize: 22.0),
                                      ),
                                    ],
                                  ),
                                  double.parse(controller.calculatePrice()) -
                                              double.parse(
                                                  '${controller.checkIn?.paid}') >
                                          0
                                      ? Row(
                                          children: [
                                            const SizedBox(width: 20),
                                            const Text(
                                              'Remaining',
                                              style: TextStyle(
                                                  color: primary,
                                                  fontSize: 22.0),
                                            ),
                                            const SizedBox(width: 70),
                                            Text(
                                              '${double.parse(controller.calculatePrice()) - double.parse('${controller.checkIn?.paid}')}',
                                              style: const TextStyle(
                                                  color: primary,
                                                  fontSize: 22.0),
                                            ),
                                          ],
                                        )
                                      : Center(),
                                ],
                              ),
                            )
                          : Center(),
                      controller.checkIn != null &&
                          controller.checkIn!.refunded != null &&
                          controller.checkIn!.refunded!
                          ? Container(
                        width: MediaQuery.of(context).size.width / 3.7,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            color: surface,
                            borderRadius:
                            BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            const Text(
                              'REFUNDED',
                              style: TextStyle(
                                  color: primary, fontSize: 20.0),
                            ),
                            const SizedBox(width: 80),
                            Text("${controller.checkIn?.refundedAmount}",
                              style: const TextStyle(
                                  color: primary, fontSize: 20.0),
                            ),
                          ],
                        ),
                      )
                          : Center(),
                      Container(
                        width: MediaQuery.of(context).size.width / 3.7,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            color: border,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            const Text(
                              'TOTAL',
                              style: TextStyle(color: primary, fontSize: 25.0),
                            ),
                            const SizedBox(width: 100),
                            Text(
                              controller.calculatePrice(),
                              style: const TextStyle(
                                  color: primary, fontSize: 25.0),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
              controller.checkPaymentIsDone()
                  ? paymentBtn(controller, context)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            visaBtn(controller, context),
                            cashBtn(controller, context),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    ),
  );
}
