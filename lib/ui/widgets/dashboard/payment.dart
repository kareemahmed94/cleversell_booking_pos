import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';

Widget payment(DashboardController controller, context) {
  bool isPaymentMethodIsCash =
      controller.checkIn != null && controller.checkIn?.paymentMethod == 'cash';
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * (2 / 3),
      padding: const EdgeInsets.only(right: 100, left: 100),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL',
                  style: TextStyle(fontSize: 40.0, color: highlight)),
              Text(controller.calculatePrice(),
                  style: const TextStyle(fontSize: 40.0, color: highlight)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('OUTSTANDING',
                  style: TextStyle(fontSize: 40.0, color: highlight)),
              Text(controller.calculatePrice(),
                  style: const TextStyle(fontSize: 40.0, color: highlight)),
            ],
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 400,
            height: 100,
            child: TextField(
              controller: controller.refundAmount,
              style:
                  const TextStyle(fontSize: 20.0, height: 2.0, color: background),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                filled: true,
                fillColor: inputBackground,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: highlight, width: 10.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: highlight, width: 10.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Type Here Amount',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 230,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: highlight, width: 3),
                  color: !isPaymentMethodIsCash ? background : highlight,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(3, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.payment_outlined,
                        color: !isPaymentMethodIsCash ? highlight : background,
                        size: 80),
                    Text(
                      'VISA',
                      style: TextStyle(
                          color:
                              !isPaymentMethodIsCash ? highlight : background,
                          fontSize: 25),
                    )
                  ],
                ),
              ),
              Container(
                width: 230,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: highlight, width: 3),
                  color: isPaymentMethodIsCash ? background : highlight,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(3, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.money,
                        color: isPaymentMethodIsCash ? highlight : background,
                        size: 80),
                    Text(
                      'CASH',
                      style: TextStyle(
                          color: isPaymentMethodIsCash ? highlight : background,
                          fontSize: 25),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => controller.checkRefund('visa', context),
                child:
                Container(
                width: 230,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: highlight, width: 3),
                  color: highlight,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(3, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.payment_outlined, color: background, size: 80),
                    Text(
                      'CASH REFUND',
                      style: TextStyle(color: background, fontSize: 25),
                    )
                  ],
                ),
              ),
              ),
              GestureDetector(
                onTap: () => controller.checkRefund('cash', context),
                child: Container(
                  width: 230,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: highlight, width: 3),
                    color: highlight,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(3, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.payment_outlined, color: background, size: 80),
                      Text(
                        'VISA REFUND',
                        style: TextStyle(color: background, fontSize: 25),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
