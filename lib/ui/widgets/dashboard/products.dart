import '../../../core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/colors.dart';
import '../../../core/data/model/product.dart';


Widget products(DashboardController controller, context) {
  return controller.showProducts
      ? SizedBox(
      height: 450,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
                children: controller.products
                    .map((product) => productWrapper(controller, context, product))
                    .toList()),
            controller.selectedProduct != null
                ? SizedBox(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                          "${controller.selectedProduct?.name}",
                          style: const TextStyle(
                              color: highlight, fontSize: 30)),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Price",
                            style: TextStyle(
                                color: primary, fontSize: 25)),
                        Text(
                            "${controller.selectedProduct?.price} L.E",
                            style: TextStyle(
                                color: primary, fontSize: 25)),
                      ],
                    ),
                    SizedBox(
                      height: 250,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 70,
                          ),
                          const Divider(
                            thickness: 1,
                            color: primary,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 30,
                              ),
                              SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    iconSize: 20.0,
                                    padding: const EdgeInsets.only(
                                        top: 10.0),
                                    splashColor: highlight,
                                    highlightColor:
                                    Colors.transparent,
                                    icon: const Icon(
                                      Icons.remove,
                                      color: secondaryDim,
                                    ),
                                    onPressed: () => controller
                                        .updateQuantity(false),
                                  )),
                              const SizedBox(
                                width: 50,
                              ),
                              Text(
                                "${controller.quantity.text}",
                                style: const TextStyle(
                                    color: primary, fontSize: 20),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: IconButton(
                                    color: highlight,
                                    iconSize: 20.0,
                                    padding: const EdgeInsets.only(
                                        top: 10.0),
                                    splashColor: highlight,
                                    highlightColor:
                                    Colors.transparent,
                                    icon: const Icon(
                                      Icons.add,
                                      color: secondaryDim,
                                    ),
                                    onPressed: () => controller
                                        .updateQuantity(true),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ))
                : const SizedBox(width: 250),
          ],
        ),
      ))
      : const SizedBox(width: 0, height: 0);
}
Widget productWrapper(DashboardController controller, context, ProductModel product) {
  return Container(
    margin: const EdgeInsets.only(top: 20, right: 40, bottom: 10, left: 50),
    width: 300,
    height: 75,
    child: ElevatedButton(
      style: ButtonStyle(
          shadowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return Colors.black;
            },
          ),
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
