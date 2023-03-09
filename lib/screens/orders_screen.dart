import '../core/controller/order_controller.dart';
import '../core/data/model/room.dart';
import '../ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/colors.dart';
import 'package:intl/intl.dart';

import '../ui/widgets/common/loader.dart';

class OrdersScreen extends StatelessWidget {
  final OrdersController controller;

  const OrdersScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
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
                Container(
                  margin: const EdgeInsets.only(left: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width /3.5),
                      Center(
                        child: Column(
                          children: [
                            Row(
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
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Text(
                                              DateFormat.yMMMd()
                                                  .format(controller.startDate),
                                              style: const TextStyle(
                                                  color: secondary)),
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
                                              DateFormat.yMMMd()
                                                  .format(controller.endDate),
                                              style: const TextStyle(
                                                  color: secondary)),
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
                            const SizedBox(
                              width: 200,
                              child: Divider(
                                color: secondary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 200,
                  child: TextFormField(
                      controller: controller.searchNumber,
                      style: const TextStyle(color: secondary),
                      cursorColor: secondary,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondaryDark),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'PHONE OR INVOICE NUMBER',
                        hintStyle: TextStyle(color: secondaryDark),
                        labelStyle: TextStyle(color: secondaryDark),
                        hintText: "PHONE OR INVOICE NUMBER",
                        prefixIcon: Icon(Icons.search, color: secondary),
                      ),
                      onChanged: (value) => controller.search(value)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                iconSize: 30.0,
                padding: const EdgeInsets.all(0.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: controller.page - 1 != 0 &&
                      controller.allOrders.isNotEmpty
                      ? highlight
                      : primaryDim,
                ),
                onPressed: () => controller.updatePage('prev'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 5 / 6,
                height: MediaQuery.of(context).size.height * 1 / 2,
                child: controller.loading == false
                    ? controller.orders.isNotEmpty
                    ? DataTable(
                  showBottomBorder: true,
                  border: const TableBorder(
                      horizontalInside: BorderSide(
                          width: 1,
                          color: secondaryDark,
                          style: BorderStyle.solid)),
                  columns: const <DataColumn>[
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                  ],
                  rows: controller.orders.isNotEmpty
                      ? controller.orders.map<DataRow>((booking) {
                    var w = DataRow(
                      cells: <DataCell>[
                        const DataCell(Icon(
                            Icons.remove_red_eye_outlined,
                            color: highlight)),
                        DataCell(Text('${booking.id}',
                            style: const TextStyle(
                                color: primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))),
                        DataCell(Text('${booking.userName}',
                            style: const TextStyle(
                                color: primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))),
                        DataCell(Text('${booking.userPhone}',
                            style: const TextStyle(
                                color: primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))),
                        DataCell(Text('${booking.productName}',
                            style: const TextStyle(
                                color: primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))),
                        DataCell(Text(
                            '${booking.date} - ${booking.time}',
                            style: const TextStyle(
                                color: primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))),
                        DataCell(Text('${booking.roomName}',
                            style: const TextStyle(
                                color: primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))),
                      ],
                    );
                    return w;
                  }).toList()
                      : [],
                )
                    : const Center(
                  child: Text(
                    "No Orders found in this timespan",
                    style: TextStyle(
                        color: highlight,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                )
                    : const Center(child: Loader()),
              ),
              IconButton(
                iconSize: 30.0,
                padding: const EdgeInsets.all(0.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: controller.page + 1 != controller.pages &&
                      controller.allOrders.isNotEmpty
                      ? highlight
                      : primaryDim,
                ),
                onPressed: () => controller.updatePage('next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  dateTimeRangePicker(context) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: DateTimeRange(
          end: controller.endDate,
          start: controller.startDate,
        ),
        builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 500.0,
                          maxWidth: 300.0,
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
      controller.pickDateRange(picked);
    }
  }
}
