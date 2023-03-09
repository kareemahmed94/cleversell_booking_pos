
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

Widget appBar(context) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    width: MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 15,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: surface,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: IconButton(
            iconSize: 50.0,
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.menu,
              color: primary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        Container(
          width: 55,
          height: 55,
          margin: const EdgeInsets.only(top: 15),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage("assets/images/logo-icon.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: IconButton(
            iconSize: 40.0,
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.logout,
              color: primary,
            ),
            onPressed: () => {},
          ),
        ),
      ],
    ),
  );
}
