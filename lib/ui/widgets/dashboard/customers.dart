import 'package:flutter/material.dart';
import '../../../core/controller/dashboard_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/data/model/customer.dart';
import '../common/loader.dart';

Widget customersTableHead(DashboardController controller, context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: controller.searchTerm,
              style: const TextStyle(color: secondaryDim),
              onChanged: (val) => controller.getCustomers(val),
              decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: secondaryDim,
                  ),
                  labelText: 'Phone or invoice Number',
                  labelStyle: TextStyle(color: secondaryDim),
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ),
          const SizedBox(
            width: 130,
          ),
          IconButton(
            iconSize: 20.0,
            padding: const EdgeInsets.only(top: 10.0),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(
              Icons.add,
              color: secondaryDim,
            ),
            onPressed: () => controller.showAddCustomerDialog(context),
          ),
          IconButton(
            iconSize: 20.0,
            padding: const EdgeInsets.only(top: 10.0),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(
              Icons.qr_code_scanner,
              color: secondaryDim,
            ),
            onPressed: () => controller.prevDate(),
          ),
        ],
      ),
      const SizedBox(
        width: double.infinity,
        child: Divider(
          color: secondary,
        ),
      ),
    ],
  );
}

Widget customersTable(DashboardController controller, context) {
  return controller.showCustomers
      ? Row(
    children: [
      TextButton(
        onPressed: () => {},
        // style: _scrollButtonStyle,
        child: const Icon(
          Icons.arrow_back_ios,
          color: highlight,
          size: 40.0,
        ),
      ),
      SizedBox(
        // width: 550,
        width: MediaQuery.of(context).size.width / 2,
        height: 400,
        child: Column(
          children: [
            customersTableHead(controller, context),
            controller.customers.isNotEmpty
                ? Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: controller.customers
                        .map((CustomerModel customer) =>
                        customerRow(controller, context, customer))
                        .toList(),
                  )),
            )
                : const Center(
              child: Loader(),
            )
          ],
        ),
      ),
      TextButton(
        onPressed: () => {},
        // style: _scrollButtonStyle,
        child: const Icon(
          Icons.arrow_forward_ios,
          color: highlight,
          size: 40.0,
        ),
      ),
    ],
  )
      : SizedBox(width: 0, height: 0);
}

Widget customerRow(DashboardController controller, context, CustomerModel customer) {
  // print("customersv");
  // print(customer.id);
  return Column(
    children: [
      TextButton(
          onPressed: () {
            controller.selectCustomer(customer);
          },
          child: Container(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            color: controller.selectedCustomer != null &&
                controller.selectedCustomer?.id == customer.id
                ? success
                : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 60,
                ),
                SizedBox(
                  width: 150,
                  child: Text("${customer.name}",
                      style: const TextStyle(color: primary, fontSize: 20)),
                ),
                const SizedBox(
                  width: 50,
                ),
                SizedBox(
                  width: 150,
                  child: Text("${customer.phone?.replaceAll('-', '')}",
                      style: const TextStyle(color: primary, fontSize: 20)),
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () =>
                        controller.openEditCustomerDialog(context, customer),
                    // style: _scrollButtonStyle,
                    child: Icon(
                      Icons.mode_edit_sharp,
                      color: controller.selectedCustomer != null &&
                          controller.selectedCustomer?.id == customer.id
                          ? background
                          : highlight,
                      size: 25.0,
                    ),
                  ),
                ),
              ],
            ),
          )),
      const SizedBox(
        width: double.infinity,
        child: Divider(
          color: secondary,
        ),
      ),
    ],
  );
}
