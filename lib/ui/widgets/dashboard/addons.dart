import '../../../core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/colors.dart';
import '../../../core/data/model/addon_product.dart';

Widget addonProducts(DashboardController controller, context) {
  return controller.showAddonProducts
      ? SizedBox(
          height: 450,
          child: SingleChildScrollView(
            child: Row(
              children: [
                Container(
                    width: 800,
                    height: 800,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CustomScrollView(
                      primary: false,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(0),
                          sliver: SliverGrid.count(
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            crossAxisCount: 3,
                            children: controller.addonProducts
                                .map((product) =>
                                    addonWrapper(controller, context, product))
                                .toList(),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ))
      : const SizedBox(width: 0, height: 0);
}

Widget addonWrapper(
    DashboardController controller, context, AddonProductModel product) {
  return Container(
    margin: const EdgeInsets.only(top: 20, right: 40, bottom: 100, left: 50),
    width: 200,
    height: 50,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                if (controller.checkProdInSelectedAddons(product)) {
                  return highlight;
                }
                return Colors.black;
              }
              if (controller.checkProdInSelectedAddons(product)) {
                return Colors.transparent;
              }
              return placeholder;
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            side: BorderSide(
                color: controller.checkProdInSelectedAddons(product)
                    ? highlight
                    : background,
                // color: placeholder,
                width: controller.checkProdInSelectedAddons(product) ? 3 : 2,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0),
          ))),
      onPressed: () => controller.selectAddonProduct(product),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${product.name}",
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.w400, color: primary),
          ),
          const SizedBox(
            width: double.infinity,
            child: Divider(
              thickness: 1,
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          controller.checkProdInSelectedAddons(product)
              ? Container(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: CircleAvatar(
                              radius: 40,
                              backgroundColor: secondaryDark,
                              child: IconButton(
                                color: primary,
                                iconSize: 20.0,
                                padding: const EdgeInsets.only(top: 10.0),
                                splashColor: highlight,
                                highlightColor: Colors.transparent,
                                icon: const Icon(
                                  Icons.remove,
                                  color: secondaryDim,
                                ),
                                onPressed: () => controller.updateAddonQuantity(
                                    product, false),
                              ))),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        controller.getAddonProdQty(product),
                        style: const TextStyle(color: primary, fontSize: 20),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                              radius: 40,
                              backgroundColor: secondaryDark,
                              child: IconButton(
                                color: highlight,
                                iconSize: 20.0,
                                padding: const EdgeInsets.only(top: 10.0),
                                splashColor: highlight,
                                highlightColor: Colors.transparent,
                                icon: const Icon(
                                  Icons.add,
                                  color: secondaryDim,
                                ),
                                onPressed: () => controller.updateAddonQuantity(
                                    product, true),
                              ))),
                    ],
                  ),
                )
              : const Center(),
        ],
      ),
    ),
  );
}
