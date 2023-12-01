import 'package:cleversell_booking/ui/main_screen.dart';
import 'package:cleversell_booking/ui/widgets/dashboard/calendar.dart';
import 'package:cleversell_booking/ui/widgets/dashboard/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/controller/dashboard_controller.dart';
import '../ui/widgets/dashboard/addons.dart';
import '../ui/widgets/dashboard/customers.dart';
import '../ui/widgets/dashboard/form.dart';
import '../ui/widgets/dashboard/items.dart';
import '../ui/widgets/dashboard/products.dart';
import '../ui/widgets/dashboard/rooms.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller;

  const DashboardScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: controller,
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (_) => Screen(
            showAppBar: true,
            showDrawer: true,
            body: _body(context),
            footer: Center(),
            // footer: const Center()
            ));
  }

  Widget _body(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: Row(
        children: [
          controller.showPayment ? payment(controller, context) :
          Container(
            width: MediaQuery.of(context).size.width * (2 / 3),
            // height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                rooms(controller, context),
                SizedBox(
                  height: 450,
                  child: Column(
                    children: [
                      controller.showCustomers ||
                          controller.showProducts ||
                          controller.showAddonProducts
                          ? const Center()
                          : calendar(context, controller),
                      customersTable(controller, context),
                      products(controller, context),
                      addonProducts(controller, context)
                    ],
                  ),
                ),
              ],
            ),
          ),
          form(controller, context)
        ],
      ),
    );
  }
}
