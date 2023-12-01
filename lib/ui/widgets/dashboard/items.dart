import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/colors.dart';

dateTimeRangePicker(DashboardController controller, context) async {
  DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: controller.startDate,
      lastDate: controller.endDate,
      initialDateRange: DateTimeRange(
        end: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 13),
        start: DateTime.now(),
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
  print("picked");
  controller.pickDateRange(picked);
}

Widget divider(context) {
  return const SizedBox(
    width: double.infinity,
    child: Divider(
      thickness: 3,
      color: background,
    ),
  );
}

Widget depositInputRow(DashboardController controller, context) {
  return Row(
    // spacing: 60, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 120,
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, right: 20.0),
        child: const Text(
          "DEPOSIT",
          style: TextStyle(
              color: secondary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      Container(
        padding: const EdgeInsets.only(right: 20.0),
        width: 60,
        height: 40,
        child: TextFormField(
          controller: controller.deposit,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(color: primary, fontSize: 15),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryDim),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryDim),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'deposit',
            labelStyle: TextStyle(color: primaryDim, fontSize: 15),
          ),
        ),
      ),
    ],
  );
}

Widget bookingTypes(DashboardController controller, context) {
  return Container(
    child: Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        TextButton(
            onPressed: () => controller.changeType('check_in'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80,
                      child: Text('Walk in',
                          style: TextStyle(
                              fontSize: 20.0,
                              color:
                              controller.isBookingTypeActive('check_in')
                                  ? highlight
                                  : primary)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: Divider(
                    color: controller.isBookingTypeActive('check_in')
                        ? highlight
                        : primary,
                  ),
                )
              ],
            )),
        TextButton(
            onPressed: () => controller.changeType('reservation'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text('Reservation',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: controller
                                  .isBookingTypeActive('reservation')
                                  ? highlight
                                  : primary)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: Divider(
                    color: controller.isBookingTypeActive('reservation')
                        ? highlight
                        : primary,
                  ),
                )
              ],
            )),
        TextButton(
            onPressed: () => controller.changeType('product'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80,
                      child: Text('Product',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: controller.isBookingTypeActive('product')
                                  ? highlight
                                  : primary)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 80,
                  height: 30,
                  child: Divider(
                    color: controller.isBookingTypeActive('product')
                        ? highlight
                        : primary,
                  ),
                )
              ],
            )),
      ],
    ),
  );
}

Widget typeRow(DashboardController controller, context) {
  return Row(
    // spacing: controller.selectedRoom == null ? 40 : 60,
    // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: const Text(
          "TYPE",
          style: TextStyle(
              color: primary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      SizedBox(width: 80),
      Container(
          width: 120,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.getTypeTitle(controller.checkIn?.type),
              style: const TextStyle(fontSize: 20.0, color: highlight),
            ),
          )),
    ],
  );
}

Widget invoiceRow(DashboardController controller, context) {
  return Row(
    // spacing: controller.selectedRoom == null ? 40 : 60,
    // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: const Text(
          "INVOICE",
          style: TextStyle(
              color: primary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      SizedBox(width: 80),
      Container(
          width: 120,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "${controller.checkIn?.id}",
              style: const TextStyle(fontSize: 20.0, color: highlight),
            ),
          )),
    ],
  );
}

Widget roomSelectRow(DashboardController controller, context) {
  return Row(
    // spacing: controller.selectedRoom == null ? 40 : 60,
    // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: const Text(
          "ROOM",
          style: TextStyle(
              color: primary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      SizedBox(width: controller.selectedRoom == null ? 60 : 80),
      Container(
          width: 120,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: controller.selectedRoom == null
              ? TextButton(
              onPressed: () => controller.toggleShowRooms(),
              child: const SizedBox(
                child: Text("Select Room",
                    style: TextStyle(fontSize: 20.0, color: primary)),
              ))
              : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "${controller.selectedRoom?.name}",
              style: const TextStyle(fontSize: 20.0, color: highlight),
            ),
          )),
    ],
  );
}

Widget promoCodeRow(DashboardController controller, context) {
  return Row(
    // spacing: 60, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: const Text(
          "Promocode",
          style: TextStyle(
              color: secondary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      Container(
        width: 100,
        child: controller.selectedPromoCode == null
            ? TextButton(
          onPressed: () => controller.confirmPromoCodeDialog(context),
          child: const SizedBox(
            child: Text("Select",
                style: TextStyle(fontSize: 20.0, color: secondaryDark)),
          ),
        )
            : Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("${controller.selectedPromoCode?.code}",
                    style: const TextStyle(
                        fontSize: 20.0, color: highlight))),
            IconButton(
                iconSize: 20.0,
                onPressed: () => controller.removePromo(),
                icon: const Icon(
                  Icons.delete_forever,
                  color: primary,
                )),
          ],
        ),
      )
    ],
  );
}

Widget addonProductRow(DashboardController controller, context) {
  return Column(
    children: [
      Row(
        // spacing: 60, // set spacing here
        children: [
          const SizedBox(width: 60),
          Container(
            width: !controller.checkSelectedAddonProduct() ? 100 : 120,
            // padding: const EdgeInsets.only(top: 12.0),
            child: const Text(
              "Add-on Products",
              style: TextStyle(
                  color: secondary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(width: !controller.checkSelectedAddonProduct() ? 80 : 60),
          Container(
              width: 100,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: !controller.checkCheckedOut() ? controller.checkSelectedAddonProduct()
                  ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 40),
                  height: 20,
                  child: IconButton(
                      iconSize: 15.0,
                      onPressed: () =>
                          controller.toggleShowAddonProducts(),
                      icon: const Icon(
                        Icons.edit,
                        color: primary,
                      )),
                ),
              )
                  : TextButton(
                onPressed: () => controller.toggleShowAddonProducts(),
                child: const SizedBox(
                  child: Text("Select",
                      style: TextStyle(
                          fontSize: 20.0, color: secondaryDark)),
                ),
              ): Center()) ,
        ],
      ),
      Column(
        children: controller.selectedAddonProducts
            .map((addonProd) => Row(
          children: [
            const SizedBox(width: 60),
            Container(
              width: 100,
              // padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "${addonProd['product']?.name} × ${addonProd['quantity']}",
                style: const TextStyle(
                    color: primary,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(width: 80),
            Container(
                width: 100,
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("${addonProd['product']?.price}",
                        style: const TextStyle(
                            fontSize: 20.0, color: primary)))),
          ],
        ))
            .toList(),
      ),
      controller.checkSelectedAddonProduct()
          ? SizedBox(
        width: 260,
        child: Column(
          children: [
            SizedBox(height: 5),
            const Divider(
              color: primary,
            ),
            SizedBox(height: 10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style: TextStyle(fontSize: 20.0, color: primary)),
                SizedBox(width: 150),
                Text("${controller.calculateAddonsPrice()} L.E",
                    style: const TextStyle(
                        fontSize: 20.0, color: primary)),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      )
          : Center()
    ],
  );
}

Widget selectCustomerRow(DashboardController controller, context) {
  return Column(
    children: [
      Row(
        // spacing: 60, // set spacing here
        children: [
          const SizedBox(width: 60),
          Container(
            width: 100,
            // padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "CUSTOMER",
              style: TextStyle(
                  color: controller.selectedCustomer == null
                      ? secondary
                      : primary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(width: 60),
          Container(
              width: controller.selectedCustomer == null ? 100 : 150,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: !controller.checkCheckedOut() ? controller.selectedCustomer == null
                  ? TextButton(
                onPressed: () => controller.toggleShowCustomers(),
                child: const SizedBox(
                  child: Text("Select",
                      style: TextStyle(
                          fontSize: 20.0, color: secondaryDark)),
                ),
              )
                  : Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 40),
                  height: 20,
                  child: IconButton(
                      iconSize: 15.0,
                      onPressed: () => controller.toggleShowCustomers(),
                      icon: const Icon(
                        Icons.edit,
                        color: primary,
                      )),
                ),
              ): Center()),
        ],
      ),
      controller.selectedCustomer == null
          ? Center()
          : Row(
        // spacing: 60, // set spacing here
        children: [
          const SizedBox(width: 60),
          Container(
            width: 100,
            // padding: const EdgeInsets.only(top: 12.0),
            child: const Text(
              "NAME",
              style: TextStyle(
                  color: primary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(width: 60),
          Container(
              width: 100,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("${controller.selectedCustomer?.name}",
                      style: const TextStyle(
                          fontSize: 20.0, color: primary)))),
        ],
      ),
      controller.selectedCustomer == null
          ? Center()
          : Row(
        // spacing: 60, // set spacing here
        children: [
          const SizedBox(width: 60),
          Container(
            width: 100,
            // padding: const EdgeInsets.only(top: 12.0),
            child: const Text(
              "PHONE",
              style: TextStyle(
                  color: primary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(width: 60),
          Container(
              width: 100,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("${controller.selectedCustomer?.phone}",
                      style: const TextStyle(
                          fontSize: 20.0, color: primary)))),
        ],
      ),
    ],
  );
}

Widget DOCustomerNameRow(DashboardController controller, context) {
  return Row(
    // spacing: 60, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
        child: const Text(
          "DO Name",
          style: TextStyle(
              color: secondary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      SizedBox(
        width: 100,
        height: 40,
        child: TextFormField(
          controller: controller.doName,
          focusNode: controller.doNfocusNode,
          // keyboardType: TextInputType.number,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(color: primary, fontSize: 15),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryDim),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryDim),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: '',
            labelStyle: TextStyle(color: primaryDim, fontSize: 15),
          ),
        ),
      ),
    ],
  );
}

Widget DOCustomerPhoneRow(DashboardController controller, context) {
  return Row(
    // spacing: 60, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
        child: const Text(
          "DO Phone",
          style: TextStyle(
              color: secondary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      SizedBox(
        width: 100,
        height: 40,
        child: TextFormField(
          controller: controller.doPhone,
          // keyboardType: TextInputType.number,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          focusNode: controller.doPFocusNode,
          style: const TextStyle(color: primary, fontSize: 15),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryDim),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryDim),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: '',
            labelStyle: TextStyle(color: primaryDim, fontSize: 15),
          ),
        ),
      ),
    ],
  );
}

Widget selectProductsRow(DashboardController controller, context) {
  return Column(
    children: [
      !controller.checkCheckedOut() ?controller.selectedProduct != null
          ? Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.only(right: 40),
          height: 20,
          child: IconButton(
              iconSize: 15.0,
              onPressed: () => controller.toggleShowProducts(),
              icon: const Icon(
                Icons.edit,
                color: primary,
              )),
        ),
      )
          : Center() : Center(),
      Row(
        // spacing: 60, // set spacing here
        children: [
          const SizedBox(width: 60),
          Container(
            width: 100,
            // padding: const EdgeInsets.only(top: 12.0),
            child: const Text(
              "PRODUCTS",
              style: TextStyle(
                  color: secondary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(width: controller.selectedProduct == null ? 60 : 80),
          Container(
              width: 100,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: controller.selectedProduct == null
                  ? TextButton(
                onPressed: () => controller.toggleShowProducts(),
                child: const SizedBox(
                  child: Text("Select",
                      style: TextStyle(
                          fontSize: 20.0, color: secondaryDark)),
                ),
              )
                  : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("${controller.selectedProduct?.name}",
                      style: const TextStyle(
                          fontSize: 20.0, color: highlight)))),
        ],
      ),
      controller.selectedProduct != null
          ? SizedBox(
        width: 260,
        child: Column(
          children: [
            SizedBox(height: 5),
            const Divider(
              color: primary,
            ),
            SizedBox(height: 10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style: TextStyle(fontSize: 20.0, color: primary)),
                SizedBox(width: 150),
                Text(
                    "${double.parse('${controller.selectedProduct?.price}') * int.parse(controller.quantity.text)} L.E",
                    style: const TextStyle(
                        fontSize: 20.0, color: primary)),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      )
          : Center()
    ],
  );
}

Widget fullPaymentCheckRow(DashboardController controller, context) {
  return Row(
    // spacing: 60, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        padding: const EdgeInsets.only(top: 12.0),
        child: const Text(
          "Full Payment",
          style: TextStyle(
              color: secondary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      Container(
          width: 80,
          // padding: const EdgeInsets.only(bottom: 10.0),
          child: Checkbox(
            checkColor: Colors.white,
            // fillColor: primary,
            value: controller.fullPayment,
            onChanged: (bool? value) => controller.updateFullPayment(value),
          )),
    ],
  );
}

Widget selectDateTimeRow(DashboardController controller, context) {
  return Row(
    // spacing: 80, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          controller.bookingType == 'reservation' ? "Date Time" : "Date",
          style: const TextStyle(
              color: primary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      SizedBox(
          width: 150,
          child: GestureDetector(
            onTap: () => {},
            child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                // decoration: const BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(width: 1.0, color: primaryDim))),
                child: Text('${controller.getCheckInDateTime()}',
                  style: const TextStyle(color: primary, fontSize: 20.0),
                )),
          ))
    ],
  );
}

Widget selectDateRow(DashboardController controller, context) {
  return Row(
    // spacing: 80, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          controller.bookingType == 'reservation' ? "Date Time" : "Date",
          style: const TextStyle(
              color: primary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 60),
      SizedBox(
          width: 150,
          child: GestureDetector(
            onTap: () => controller.bookingType == 'reservation'
                ? controller.showCheckInDateTimePicker(context)
                : controller.showCheckInDatePicker(context),
            child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                // decoration: const BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(width: 1.0, color: primaryDim))),
                child: Text(
                  controller.bookingType == 'reservation'
                      ? controller.checkInDateTime == ''
                      ? 'Select Date'
                      : controller.checkInDateTime
                      : controller.checkInDate == ''
                      ? 'Select Date'
                      : controller.checkInDate,
                  style: const TextStyle(color: primary, fontSize: 20.0),
                )),
          ))
    ],
  );
}

Widget selectTimeRow(DashboardController controller, context) {
  return Row(
    // spacing: 100, // set spacing here
    children: [
      const SizedBox(width: 60),
      Container(
        width: 100,
        // padding: const EdgeInsets.only(top: 12.0),
        child: const Text(
          "Time",
          style: TextStyle(
              color: primary, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 80),
      SizedBox(
          width: 100,
          child: GestureDetector(
            // onTap: () => controller.showCheckInTimePicker(context),
            onTap: () => controller.showCheckInTimePicker(context),
            child: Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                // decoration: const BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(width: 1.0, color: primaryDim))),
                child: Text(
                  controller.checkInTime == ''
                      ? 'Select Time'
                      : controller.checkInTime,
                  style: TextStyle(color: primary, fontSize: 20.0),
                )),
          ))
    ],
  );
}

Widget childrenRow(DashboardController controller, context) {
  return Column(
    children: [
      Row(
        // spacing: 60, // set spacing here
        children: [
          const SizedBox(width: 60),
          Container(
            width: 150,
            height: 40,
            // padding: const EdgeInsets.only(top: 12.0),
            child: const Text(
              "Customer Children",
              style: TextStyle(
                  color: secondary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(width: 80 ),
        ],
      ),
      Column(
        children: controller.selectedCustomer!.children!
            .map((child) => Row(
          children: [
            const SizedBox(width: 60),
            Container(
              width: 100,
              height: 40,
              // padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "${child['name']}",
                style: const TextStyle(
                    color: primary,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300),
              ),
            ),

            SizedBox(width: 80),
            // Container(
            //     width: 100,
            //     padding: const EdgeInsets.only(bottom: 10.0),
            //     child: Padding(
            //         padding: const EdgeInsets.only(top: 10),
            //         child: Text("${addonProd['product']?.price}",
            //             style: const TextStyle(
            //                 fontSize: 20.0, color: primary)))),
          ],
        ))
            .toList(),
      ),
    ],
  );
}