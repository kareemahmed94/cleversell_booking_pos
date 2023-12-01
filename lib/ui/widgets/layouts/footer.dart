import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';

Widget footer(context, staff, printerStatus) {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('kk:mm:ss').format(now);
  String formattedDate = DateFormat('EEE d MMM').format(now);

  return Container(
    margin: const EdgeInsets.only(top: 20),
    width: MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 15,
    height: 20,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: surface,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              // width: 20,
              height: 20,
              child: Text("${staff != null ? staff['name'] : ''}",
                  style: const TextStyle(color: Colors.white)),
            ),

            const SizedBox(
              width: 50,
            ),
            SizedBox(
              // width: 100,
              height: 20,
              child: Text("${staff != null ? staff['staffId'] : ''}",
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              // width: 100,
              height: 20,
              child:
              Text(formattedTime, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              // width: 100,
              height: 20,
              child:
              Text(formattedDate, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              // width: 100,
              height: 20,
              child: Text(
                  "Printer: ${printerStatus ? 'connected' : 'Not Connected'}",
                  style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              width: 30,
            ),
          ],
        ),


      ],
    ),
  );
}
