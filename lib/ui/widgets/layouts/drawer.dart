import 'package:cleversell_booking/core/controller/cash_in_controller.dart';
import 'package:cleversell_booking/core/controller/check_in_controller.dart';
import 'package:cleversell_booking/core/controller/settings_controller.dart';
import 'package:cleversell_booking/core/data/repository/addon_product_repository.dart';
import 'package:cleversell_booking/core/data/repository/branch_repository.dart';
import 'package:cleversell_booking/core/data/repository/cash_in_repository.dart';
import 'package:cleversell_booking/core/data/repository/check_in_repository.dart';
import 'package:cleversell_booking/core/data/repository/customer_repository.dart';
import 'package:cleversell_booking/core/data/repository/product_repository.dart';
import 'package:cleversell_booking/core/data/repository/promo_code_repository.dart';
import 'package:cleversell_booking/core/data/repository/staff_repository.dart';
import 'package:cleversell_booking/screens/check_outs_screen.dart';
import 'package:cleversell_booking/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/controller/check_out_controller.dart';
import '../../../core/controller/dashboard_controller.dart';
import '../../../core/controller/order_controller.dart';
import '../../../core/data/repository/booking_repository.dart';
import '../../../core/data/repository/order_repository.dart';
import '../../../screens/cash_in_screen.dart';
import '../../../screens/check_ins_screen.dart';
import '../../../screens/dashboard_screen.dart';
import '../../../screens/orders_screen.dart';

Widget drawerWidget(context, staff) {
  return Drawer(
    child: Container(
      color: drawer,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0.0),
            margin: const EdgeInsets.only(bottom: 10, top: 60),
            decoration: BoxDecoration(
              color: drawer,
              border: Border(
                bottom: Divider.createBorderSide(context, color: drawer, width: 0),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    // width: 200,
                    // height: 200,
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 2.0,color: Colors.transparent),
                    //   borderRadius:  BorderRadius.all(Radius.circular(10)),
                    //   boxShadow: const [
                    //     BoxShadow(
                    //       color: Colors.black,
                    //       blurRadius: 8,
                    //       offset: Offset(2, 2), // Shadow position
                    //     ),
                    //   ],
                    // ),
                    child: Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/user-avatar.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${staff != null ? staff['name'] : ''}",
                    style: const TextStyle(
                        color: primary,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          _drawerItem("CALENDAR", Icons.calendar_today_outlined, () {
            Scaffold.of(context).closeDrawer();
            Get.off(DashboardScreen(
                DashboardController(BookingRepository(),CustomerRepository(),
                    ProductRepository(),PromoCodeRepository(),
                    AddonProductRepository(),BranchRepository(),
                    StaffRepository(),CheckInRepository()
                )));
          }),
          _drawerItem("CASH-IN", Icons.money, () {Get.off(CashInScreen(CashInController(CashInRepository())));}),
          _drawerItem("BOOKINGS", Icons.add_call, () {Get.off(CheckInsScreen(CheckInController(CheckInRepository())));}),
          _drawerItem("SETTINGS", Icons.settings, () {Get.off(SettingsScreen(SettingsController(BranchRepository())));}),



          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: TextButton(
                  onPressed: () => {
                        Get.off(OrdersScreen(OrdersController(OrderRepository())))
                      },
                  // style: _scrollButtonStyle,
                  child: const Column(
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(width: 10),
                            Text("MADE WITH ",
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300)),
                            Icon(
                              Icons.heart_broken,
                              color: highlight,
                              size: 30.0,
                            ),
                            Text(" BY QPIX.IO",
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _drawerItem(String title,IconData icon, Function to) {
  return ListTile(
    title: TextButton(
        onPressed: () => to(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    icon,
                    color: primary,
                    size: 30.0,
                  ),
                  const SizedBox(width: 10),
                  Text(title,
                      style: const TextStyle(color: primary, fontSize: 28))
                ],
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 300,
              child: Divider(
                height: 10,
                color: primary,
              ),
            ),
          ],
        )),
  );
}