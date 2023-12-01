import 'package:cleversell_booking/core/controller/check_in_controller.dart';

import '../core/controller/booking_controller.dart';
import '../core/controller/cash_in_controller.dart';
import '../core/data/model/room.dart';
import '../ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/colors.dart';
import '../core/controller/dashboard_controller.dart';
import 'package:intl/intl.dart';

import '../ui/widgets/common/loader.dart';

class CashInScreen extends StatelessWidget {
  final CashInController controller;

  const CashInScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashInController>(
        init: controller,
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (_) =>
            Screen(showAppBar: true, showDrawer: true, body: _body(context)));
  }

  Widget _body(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 50.0, left: 50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                printBtn(context),
                calendar(context),
                refreshBtn(context)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 30.0, left: 30.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.66,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 470,
                      child: numberOfPayments(context),
                    ),
                    SizedBox(
                      width: 450,
                      child: totalPayment(context),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      child: Text(
                        "CASH",
                        style: TextStyle(
                            color: primary,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 300,
                      child: totalPayments(
                          context, 'TOTAL CASH PAYMENTS', controller.totalCashPayment.toString()),
                    ),
                    SizedBox(
                      width: 300,
                      child: totalRefunds(
                          context, 'TOTAL CASH REFUNDS', controller.totalCashRefunds.toString()),
                    ),
                    SizedBox(
                      width: 300,
                      child:
                      netPayments(context, 'NET CASH PAYMENTS', controller.netCashPayments.toString()),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      child: Text(
                        "VISA",
                        style: TextStyle(
                            color: primary,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 300,
                      child: totalPayments(
                          context, 'TOTAL VISA PAYMENTS', controller.totalVisaPayment.toString()),
                    ),
                    SizedBox(
                      width: 300,
                      child: totalRefunds(
                          context, 'TOTAL VISA REFUNDS', controller.totalVisaRefunds.toString()),
                    ),
                    SizedBox(
                      width: 300,
                      child:
                          netPayments(context, 'NET VISA PAYMENTS', controller.netVisaPayments.toString()),
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

  printBtn(context) {
    return SizedBox(
      width: 200,
      child: TextButton(
          onPressed: () => controller.printInvoice(),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Icon(
                    Icons.print,
                    color: secondary,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: Text("PRINT",
                        style: TextStyle(fontSize: 22.0, color: secondary)),
                  )
                ],
              ),
              SizedBox(
                width: 150,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }


  refreshBtn(context) {
    final List<Color> loaderColors = [
      secondary,
    ];
    return SizedBox(
      width: 200,
      child: controller.loading ? Loader(colors: loaderColors) : TextButton(
          onPressed: () async => await controller.refreshPayments(),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.refresh,
                    color: secondary,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: Text("REFRESH",
                        style: TextStyle(fontSize: 22.0, color: secondary)),
                  )
                ],
              ),
              SizedBox(
                width: 150,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }

  calendar(context) {
    return Container(
      margin: const EdgeInsets.only(left: 35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Row(
              children: [
                IconButton(
                  iconSize: 20.0,
                  padding: const EdgeInsets.only(top: 10.0),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: highlight,
                  ),
                  onPressed: () => controller.prevDate(),
                ),
                TextButton(
                    onPressed: () => dateTimeRangePicker(context),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                  DateFormat.yMMMd()
                                      .format(controller.startDate),
                                  style: const TextStyle(color: secondary)),
                            ),
                            const SizedBox(
                              height: 45,
                              child: VerticalDivider(
                                width: 30,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,
                                color: secondary,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                  DateFormat.yMMMd().format(controller.endDate),
                                  style: const TextStyle(color: secondary)),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 200,
                          child: Divider(
                            color: secondaryDim,
                          ),
                        )
                      ],
                    )),
                IconButton(
                  iconSize: 20.0,
                  padding: const EdgeInsets.only(top: 10.0),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: highlight,
                  ),
                  onPressed: () => controller.nextDate(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  numberOfPayments(context) {
    return SizedBox(
      width: 300,
      child: TextButton(
          // onPressed: () => controller.showScanDialog(context),
          onPressed: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const SizedBox(
                    width: 300,
                    child: Text("NUMBER OF TRANSACTIONS",
                        style: TextStyle(fontSize: 30.0, color: highlight)),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(controller.paymentsNum.toString(),
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: highlight,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              const SizedBox(
                width: 400,
                height: 50,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }

  totalPayment(context) {
    return SizedBox(
      width: 200,
      child: TextButton(
          // onPressed: () => controller.showScanDialog(context),
          onPressed: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const SizedBox(
                    width: 250,
                    child: Text("TOTAL PAYMENT",
                        style: TextStyle(fontSize: 30.0, color: highlight)),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(controller.totalPayment.toString(),
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: highlight,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              const SizedBox(
                width: 400,
                height: 50,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }

  totalPayments(context, text, value) {
    return SizedBox(
      width: 180,
      child: TextButton(
          // onPressed: () => controller.showScanDialog(context),
          onPressed: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 180,
                    child: Text('${text}',
                        style: const TextStyle(fontSize: 20.0, color: primary)),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text('${value}',
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: primary,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              const SizedBox(
                width: 600,
                height: 50,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }

  totalRefunds(context, text, value) {
    return SizedBox(
      width: 180,
      child: TextButton(
          // onPressed: () => controller.showScanDialog(context),
          onPressed: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 180,
                    child: Text('${text}',
                        style: const TextStyle(fontSize: 20.0, color: primary)),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text('${value}',
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: primary,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              const SizedBox(
                width: 600,
                height: 50,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }

  netPayments(context, text, value) {
    return SizedBox(
      width: 180,
      child: TextButton(
          // onPressed: () => controller.showScanDialog(context),
          onPressed: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 180,
                    child: Text('${text}',
                        style: const TextStyle(fontSize: 20.0, color: highlight)),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text('${value}',
                        style:
                            const TextStyle(fontSize: 20.0, color: highlight)),
                  )
                ],
              ),
              const SizedBox(
                width: 600,
                height: 50,
                child: Divider(
                  color: secondaryDim,
                ),
              )
            ],
          )),
    );
  }

  dateTimeRangePicker(context) async {
    DateTimeRange? picked = await showDateRangePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: DateTimeRange(
          end: controller.endDate,
          start: controller.startDate,
        ),
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 500.0,
                    maxWidth: 400.0,
                  ),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        background: drawer,
                        onBackground: drawer,
                        primary: drawer,
                        onPrimary: highlight,
                        onSurface: drawer,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary: highlight, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  ),
                )
              ],
            ),
          );
        });
    if (picked != null) {
      controller.calculatePayments(picked);
    }
  }
}
