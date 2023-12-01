


import 'package:cleversell_booking/core/controller/check_in_controller.dart';
import 'package:cleversell_booking/core/data/model/check_in.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';

Widget checkInDetails(CheckInController controller, context, CheckInModel checkIn) {
  return Container(
    height: 500,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 400,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                  checkIn.id,
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
                                  "${checkIn.roomName}",
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
                                 checkIn.type == 'reservation' ? "[${checkIn.reserveDate}] "
                                     "[${DateFormat().add_jm().format(DateTime.parse('${checkIn.reserveDate} ${checkIn.reserveTime}'))}]" : "[${checkIn.date}] "
                                      "[${DateFormat().add_jm().format(DateTime.parse('${checkIn.date} ${checkIn.time}'))}]",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      ),
                      _divider(context),
                      _customer(context, checkIn),
                      _divider(context),

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
                              "${checkIn?.productName}",
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
                                  "${checkIn?.productPrice}",
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      ),
                      _divider(context),

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
                                  "L.E ${checkIn?.productPrice}",
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      ),
                      checkIn.promoCode != null
                          ? _divider(context)
                          : const Center(),
                      checkIn.promoCode != null
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
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      )
                          : const Center(),
                      checkIn.promoCode != null
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
                              padding:
                              const EdgeInsets.only(bottom: 10.0),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 11.0),
                                child: Text(
                                  "${checkIn.promoCode}",
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
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            // width: MediaQuery.of(context).size.width / 3.4,
            padding: const EdgeInsets.all(10.0),
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text(
                                'TOTAL',
                                style: TextStyle(
                                    color: primary, fontSize: 30.0),
                              ),
                              const SizedBox(width: 80),
                              Text(
                                'L.E ${checkIn.price}',
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
                checkIn.checkOutId != null
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width /
                              3.7,
                          padding: const EdgeInsets.all(5.0),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                              color: secondaryDim,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5))),
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
                    : const Center()
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _customer(context, CheckInModel checkIn) {
  return Column(
    children: [
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
                  "${checkIn.customerName}",
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
                  "${checkIn.customerPhone}",
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: primary,
                      fontWeight: FontWeight.w600),
                ),
              )),
        ],
      ),
    ],
  );
}

Widget _divider(context) {
  return const SizedBox(
    width: double.infinity,
    child: Divider(
      thickness: 5,
      color: background,
    ),
  );
}