import 'package:cleversell_booking/core/data/model/customer.dart';
import 'package:cleversell_booking/core/data/model/room.dart';
import 'package:cleversell_booking/ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../core/constants/colors.dart';
import '../core/controller/dashboard_controller.dart';
import 'package:intl/intl.dart';

import '../core/data/model/product.dart';
import '../ui/widgets/common/loader.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller;

  const DashboardScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: controller,
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (_) =>
            Screen(showAppBar: true, showDrawer: true, body: _body(context)));
  }

  Widget _body(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * (2 / 3),
            // height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _rooms(context),
                SizedBox(
                  height: 450,
                  child: Column(
                    children: [_customersTable(context), _products(context)],
                  ),
                ),
              ],
            ),
          ),
          controller.checkIn != null
              ? _chickInInvoice(context)
              : _chickIns(context)
        ],
      ),
    );
  }

  Widget _rooms(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => controller.prev(),
          // style: _scrollButtonStyle,
          child: const Icon(
            Icons.arrow_back_ios,
            color: highlight,
            size: 40.0,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.9,
          height: 150,
          child: ScrollablePositionedList.builder(
              itemCount: controller.rooms.length,
              itemBuilder: (context, index) {
                return _wrapper(context, controller.rooms[index]);
              },
              itemScrollController: controller.scrollController,
              itemPositionsListener: controller.itemPositionsListener,
              scrollDirection: Axis.horizontal),
        ),
        TextButton(
          onPressed: () => controller.next(),
          // style: _scrollButtonStyle,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: highlight,
            size: 40.0,
          ),
        ),
      ],
    );
  }

  Widget _chickIns(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              width: MediaQuery.of(context).size.width / 3.4,
              height: MediaQuery.of(context).size.height / 1.9,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
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
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: secondaryDim)),
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
                            )),
                        TextButton(
                          onPressed: () => {},
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: highlight,
                                    size: 30.0,
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 60,
                                    child: const Text("NEW",
                                        style: TextStyle(
                                            fontSize: 25.0, color: highlight)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 120,
                                child: Divider(
                                  color: highlight,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //     TextButton(
                  //         onPressed: () => {},
                  //         child: Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 const SizedBox(width: 10),
                  //                 Container(
                  //                   width: 80,
                  //                   child: const Text("WALK IN",
                  //                       style: TextStyle(
                  //                           fontSize: 20.0,
                  //                           color: secondaryDim)),
                  //                 )
                  //               ],
                  //             ),
                  //             const SizedBox(
                  //               width: 80,
                  //               child: Divider(
                  //                 color: secondary,
                  //               ),
                  //             )
                  //           ],
                  //         )),
                  //     TextButton(
                  //       onPressed: () => {},
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               const SizedBox(width: 10),
                  //               Container(
                  //                 width: 100,
                  //                 child: const Text("RESERVATION",
                  //                     style: TextStyle(
                  //                         fontSize: 20.0,
                  //                         color: secondaryDim)),
                  //               )
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             width: 100,
                  //             child: Divider(
                  //               color: secondary,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () => {},
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               const SizedBox(width: 10),
                  //               Container(
                  //                 width: 60,
                  //                 child: const Text("NEW",
                  //                     style: TextStyle(
                  //                         fontSize: 20.0,
                  //                         color: secondaryDim)),
                  //               )
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             width: 80,
                  //             child: Divider(
                  //               color: secondary,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Wrap(
                    spacing: controller.selectedRoom == null ? 40 : 60,
                    // set spacing here
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "ROOM",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: controller.selectedRoom == null ? 120 : 100,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: controller.selectedRoom == null
                              ? TextButton(
                                  onPressed: () => controller.toggleShowRooms(),
                                  child: const SizedBox(
                                    child: Text("Select Room",
                                        style: TextStyle(
                                            fontSize: 20.0, color: primary)),
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "${controller.selectedRoom?.name}",
                                    style: TextStyle(
                                        fontSize: 20.0, color: highlight),
                                  ),
                                )),
                    ],
                  ),

                  // Wrap(
                  //   spacing: 160, // set spacing here
                  //   children: [
                  //     const Padding(
                  //       padding: EdgeInsets.only(top: 12.0),
                  //       child: Text(
                  //         "DATE",
                  //         style: TextStyle(
                  //             color: primary,
                  //             fontSize: 20.0,
                  //             fontWeight: FontWeight.w300),
                  //       ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () => {},
                  //       child: const SizedBox(
                  //         child: Text("Select Date",
                  //             style:
                  //             TextStyle(fontSize: 20.0, color: primary)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),
                  Wrap(
                    spacing: 60, // set spacing here
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "CUSTOMER",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 100,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: controller.selectedCustomer == null
                              ? TextButton(
                                  onPressed: () =>
                                      controller.toggleShowCustomers(),
                                  child: const SizedBox(
                                    child: Text("Select",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: secondaryDim)),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                      "${controller.selectedCustomer?.name}",
                                      style: const TextStyle(
                                          fontSize: 20.0, color: highlight)))),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),
                  Wrap(
                    spacing: 25, // set spacing here
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "Quantity",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 130,
                          // padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextButton(
                                  onPressed: () =>
                                      controller.toggleShowCustomers(),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          iconSize: 15.0,
                                          onPressed: () => controller.changeQty('sub'),
                                          icon: const Icon(
                                            Icons.remove,
                                            color: highlight,
                                          )),
                                      SizedBox(
                                        width: 18,
                                        height: 20,
                                        child: TextFormField(
                                          controller: controller.quantity,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          style: const TextStyle(
                                              color: primary, fontSize: 15),
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: primaryDim),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: primaryDim),
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelText: '',
                                            labelStyle: TextStyle(
                                                color: primaryDim,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          iconSize: 15.0,
                                          onPressed: () => controller.changeQty('add'),
                                          icon: const Icon(
                                            Icons.add,
                                            color: highlight,
                                          ))
                                    ],
                                  ),
                                )
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),
                  Wrap(
                    spacing: 60, // set spacing here
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "PRODUCTS",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 100,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: controller.selectedProduct == null
                              ? TextButton(
                                  onPressed: () =>
                                      controller.toggleShowProducts(),
                                  child: const SizedBox(
                                    child: Text("Select",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: secondaryDim)),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                      "${controller.selectedProduct?.name}",
                                      style: const TextStyle(
                                          fontSize: 20.0, color: highlight)))),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),
                  Wrap(
                    spacing: 60, // set spacing here
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "In Advance",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 100,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Checkbox(
                            checkColor: Colors.white,
                            // fillColor: primary,
                            value: controller.inAdvance,
                            onChanged: (bool? value) => controller.updateInAdvance(value),
                          )
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),

                  // DATE TIME

                  controller.inAdvance ? Wrap(
                    spacing: 100, // set spacing here
                    children: [
                      Container(
                        width: 50,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "Date",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap: () => controller.showCheckInDatePicker(context),
                            child: Container(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                // decoration: const BoxDecoration(
                                //     border: Border(
                                //         bottom: BorderSide(width: 1.0, color: primaryDim))),
                                child: Text(
                                  controller.checkInDate == '' ? 'Select Date' : controller.checkInDate,
                                  style: const TextStyle(color: secondaryDim,fontSize: 20.0),
                                )),
                          ))
                    ],
                  ) : Center(),
                  controller.inAdvance ? const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ) : Center(),
                  controller.inAdvance ? Wrap(
                    spacing: 100, // set spacing here
                    children: [
                      Container(
                        width: 50,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "Time",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap: () => controller.showCheckInTimePicker(context),
                            child: Container(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                // decoration: const BoxDecoration(
                                //     border: Border(
                                //         bottom: BorderSide(width: 1.0, color: primaryDim))),
                                child: Text(
                                  controller.checkInTime == '' ? 'Select Time' : controller.checkInTime,
                                  style: const TextStyle(color: secondaryDim,fontSize: 20.0),
                                )),
                          ))
                    ],
                  ) : Center(),
                  controller.inAdvance ? const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ) : Center(),
                  // Wrap(
                  //   spacing: 90, // set spacing here
                  //   children: [
                  //     Container(
                  //       width: 120,
                  //       padding: const EdgeInsets.only(top: 12.0),
                  //       child: const Text(
                  //         "Add-on Products",
                  //         style: TextStyle(
                  //             color: secondaryDim,
                  //             fontSize: 20.0,
                  //             fontWeight: FontWeight.w300),
                  //       ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () => {},
                  //       child: const SizedBox(
                  //         child: Text("Select",
                  //             style: TextStyle(
                  //                 fontSize: 20.0, color: secondaryDim)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   width: double.infinity,
                  //   child: Divider(
                  //     thickness: 5,
                  //     color: background,
                  //   ),
                  // ),
                  Wrap(
                    spacing: 60, // set spacing here
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: const Text(
                          "Promocode",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: controller.selectedPromoCode == null
                            ? TextButton(
                                onPressed: () =>
                                    controller.showPromoCodeDialog(context),
                                child: const SizedBox(
                                  child: Text("Select",
                                      style: TextStyle(
                                          fontSize: 20.0, color: secondaryDim)),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                    "${controller.selectedPromoCode?.code}",
                                    style: const TextStyle(
                                        fontSize: 20.0, color: highlight))),
                      )
                    ],
                  ),
                ],
              ))),
        ),
        Container(
          // width: MediaQuery.of(context).size.width / 3.4,
          padding: const EdgeInsets.all(10.0),
          // height: MediaQuery.of(context).size.height,
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
                      Container(
                        width: MediaQuery.of(context).size.width / 3.7,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            color: highlight,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            controller.inAdvance ? const Text(
                              'IN ADVANCE',
                              style: TextStyle(color: primary, fontSize: 30.0),
                            ) : const Text(
                              'TOTAL',
                              style: TextStyle(color: primary, fontSize: 30.0),
                            ),
                            const SizedBox(width: 60),
                            controller.inAdvance ? const Center() : Text(
                              'L.E ${controller.price}',
                              style: TextStyle(color: primary, fontSize: 30.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      controller.inAdvance ? Center() :TextButton(
                        onPressed: () =>
                            controller.submitCheckIn('visa', context),
                        child: Container(
                          // width: 80,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: surface,
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
                          child: Row(
                            children: const [
                              Icon(
                                Icons.credit_card,
                                color: secondaryDim,
                                size: 30.0,
                              ),
                              Text("VISA",
                                  style: TextStyle(
                                      fontSize: 20.0, color: secondaryDim)),
                            ],
                          ),
                        ),
                      ),
                      !controller.inAdvance ? Center() :TextButton(
                        onPressed: () =>
                            controller.submitCheckIn('in_advance', context),
                        child: Container(
                          // width: 80,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: surface,
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
                          child: Row(
                            children: const [
                              Icon(
                                Icons.padding,
                                color: secondaryDim,
                                size: 30.0,
                              ),
                              Text("RESERVE",
                                  style: TextStyle(
                                      fontSize: 20.0, color: secondaryDim)),
                            ],
                          ),
                        ),
                      ),
                      controller.inAdvance ? Center() :TextButton(
                        onPressed: () =>
                            controller.submitCheckIn('cash', context),
                        child: Container(
                          // width: 80,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: surface,
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
                          child: Row(
                            children: const [
                              Icon(
                                Icons.money_outlined,
                                color: secondaryDim,
                                size: 30.0,
                              ),
                              Text("CASH",
                                  style: TextStyle(
                                      fontSize: 20.0, color: secondaryDim)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chickInInvoice(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              width: MediaQuery.of(context).size.width / 3.4,
              height: controller.scan &&
                      controller.moneyDiff != '' &&
                      controller.checkIn?.checkOutId == null
                  ? controller.scan && controller.moneyDiff != ''
                      ? MediaQuery.of(context).size.height / 2.3
                      : MediaQuery.of(context).size.height / 2
                  : controller.checkIn?.checkOutId != null
                      ? MediaQuery.of(context).size.height / 2.1
                      : MediaQuery.of(context).size.height / 2,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
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
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: secondaryDim)),
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
                            )),
                        TextButton(
                          onPressed: () => controller.initNewCheckIn(),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.add,
                                    color: secondaryDim,
                                    size: 30.0,
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 60,
                                    child: Text("NEW",
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: secondaryDim)),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "INVOICE NUMBER",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "${controller.checkIn?.id}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "ROOM",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "${controller.checkIn?.roomName}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 60,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "DATE",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 180,
                          padding: const EdgeInsets.only(bottom: 11.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "[${controller.checkIn?.date}] "
                              "[${DateFormat().add_jm().format(DateTime.parse('${controller.checkIn?.date} ${controller.checkIn?.time}'))}]",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "CUSTOMER",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 11.0),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "NAME",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "${controller.checkIn?.customerName}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "PHONE",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "${controller.checkIn?.customerPhone}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 5,
                      color: background,
                    ),
                  ),
                  Wrap(
                    spacing: 60, // set spacing here
                    children: [
                      Container(
                        width: 110,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "PRODUCT",
                          style: TextStyle(
                              color: secondaryDim,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 100,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "${controller.checkIn?.productName}",
                          style: const TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "${controller.checkIn?.productPrice}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: 270,
                    height: 0,
                    child: Divider(
                      thickness: 1,
                      color: primary,
                    ),
                  ),
                  Wrap(
                    spacing: 30, // set spacing here
                    children: [
                      Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          "TOTAL",
                          style: TextStyle(
                              color: primary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                          width: 120,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "L.E ${controller.checkIn?.productPrice}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                  controller.checkIn?.promoCode != null
                      ? const SizedBox(
                          width: double.infinity,
                          child: Divider(
                            thickness: 5,
                            color: background,
                          ),
                        )
                      : const Center(),
                  controller.checkIn?.promoCode != null
                      ? Wrap(
                          spacing: 60, // set spacing here
                          children: [
                            Container(
                              width: 100,
                              padding: const EdgeInsets.only(top: 10.0),
                              child: const Text(
                                "PROMOCODE",
                                style: TextStyle(
                                    color: secondaryDim,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Container(
                                width: 100,
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "",
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        color: primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        )
                      : const Center(),
                  controller.checkIn?.promoCode != null
                      ? Wrap(
                          spacing: 30, // set spacing here
                          children: [
                            Container(
                              width: 120,
                              padding: const EdgeInsets.only(top: 10.0),
                              child: const Text(
                                "PROMOCODE",
                                style: TextStyle(
                                    color: primary,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Container(
                                width: 120,
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 11.0),
                                  child: Text(
                                    "${controller.checkIn?.promoCode}",
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        )
                      : const Center(),
                ],
              ))),
        ),
        Container(
          // width: MediaQuery.of(context).size.width / 3.4,
          padding: const EdgeInsets.all(10.0),
          // height: MediaQuery.of(context).size.height,
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
                      Container(
                        width: MediaQuery.of(context).size.width / 3.7,
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            color: highlight,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              'TOTAL',
                              style: TextStyle(color: primary, fontSize: 30.0),
                            ),
                            const SizedBox(width: 80),
                            Text(
                              'L.E ${controller.checkIn?.price}',
                              style: const TextStyle(
                                  color: primary, fontSize: 30.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              controller.scan && controller.timeSpent != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3.7,
                              padding: const EdgeInsets.all(5.0),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                  color: secondaryDim,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  const Text(
                                    'TIME SPENT',
                                    style: TextStyle(
                                        color: primary, fontSize: 30.0),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    '${controller.timeSpent} Hours',
                                    style: const TextStyle(
                                        color: primary, fontSize: 30.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const Center(),
              controller.scan && controller.moneyDiff != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3.7,
                              padding: const EdgeInsets.all(5.0),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                  color: error,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Remaining',
                                    style: TextStyle(
                                        color: primary, fontSize: 30.0),
                                  ),
                                  const SizedBox(width: 40),
                                  Text(
                                    'L.E ${controller.moneyDiff}',
                                    style: const TextStyle(
                                        color: primary, fontSize: 30.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const Center(),
              controller.checkIn?.checkOutId == null
                  ? controller.moneyDiff == ''
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              controller.submitCheckOut(
                                                  'finish', context),
                                          child: Container(
                                            // width: 80,
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: const BoxDecoration(
                                              color: surface,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset.zero,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  color: secondaryDim,
                                                  size: 30.0,
                                                ),
                                                Text("FINISH",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: secondaryDim)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      controller.submitCheckIn('visa', context),
                                  child: Container(
                                    // width: 80,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: const BoxDecoration(
                                      color: surface,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.credit_card,
                                          color: secondaryDim,
                                          size: 30.0,
                                        ),
                                        Text("VISA",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: secondaryDim)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 50,
                                ),
                                TextButton(
                                  onPressed: () => controller.submitCheckOut(
                                      'cash', context),
                                  child: Container(
                                    // width: 80,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: const BoxDecoration(
                                      color: surface,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.money_outlined,
                                          color: secondaryDim,
                                          size: 30.0,
                                        ),
                                        Text("CASH",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: secondaryDim)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () => {},
                                      child: Container(
                                        // width: 80,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset.zero,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: primary,
                                              size: 30.0,
                                            ),
                                            Text("PAID",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: primary)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _wrapper(context, room) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 40, bottom: 30),
      width: MediaQuery.of(context).size.width / 6.6,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  if (room.id == controller.selectedRoom?.id) {
                    return success;
                  }
                  return background;
                }
                if (room.id == controller.selectedRoom?.id) {
                  return Colors.transparent;
                }
                return placeholder;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                  color: room.id == controller.selectedRoom?.id
                      ? success
                      : placeholder,
                  width: 3,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () => controller.selectRoom(room),
        child: Text(room.name,
            style: const TextStyle(
                fontSize: 21, fontWeight: FontWeight.w400, color: primary)),
      ),
    );
  }

  Widget _customerRow(context, CustomerModel customer) {
    return Column(
      children: [
        TextButton(
            onPressed: () => controller.selectCustomer(customer),
            child: Container(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              color: controller.selectedCustomer != null &&
                      controller.selectedCustomer?.id == customer.id
                  ? success
                  : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  SizedBox(
                    width: 150,
                    child: Text("${customer.name}",
                        style: const TextStyle(color: primary, fontSize: 20)),
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                  SizedBox(
                    width: 150,
                    child: Text("${customer.phone?.replaceAll('-', '')}",
                        style: const TextStyle(color: primary, fontSize: 20)),
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

  Widget _customersTableHead(context) {
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

  Widget _customersTable(context) {
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
              Container(
                width: 550,
                height: 400,
                child: Column(
                  children: [
                    _customersTableHead(context),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: controller.customers
                            .map((CustomerModel customer) =>
                                _customerRow(context, customer))
                            .toList(),
                      )),
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

  Widget _products(context) {
    return controller.showProducts
        ? SizedBox(
            height: 450,
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Column(
                      children: controller.products
                          .map((product) => _productWrapper(context, product))
                          .toList()),
                ],
              ),
            ))
        : const SizedBox(width: 0, height: 0);
  }

  Widget _productWrapper(context, ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 40, bottom: 10, left: 50),
      width: 300,
      height: 75,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  if (product.id == controller.selectedProduct?.id) {
                    return success;
                  }
                  return background;
                }
                if (product.id == controller.selectedProduct?.id) {
                  return Colors.transparent;
                }
                return placeholder;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                  color: product.id == controller.selectedProduct?.id
                      ? success
                      : placeholder,
                  // color: placeholder,
                  width: 3,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () => controller.selectProduct(product),
        child: Text("${product.name}",
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w400, color: primary)),
      ),
    );
  }

  dateTimeRangePicker(context) async {
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
}
