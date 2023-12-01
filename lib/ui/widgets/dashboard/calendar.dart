import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';

Widget calendar(context, DashboardController controller) {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('kk:mm:ss').format(now);
  String formattedDate = DateFormat('EEE d MMM').format(now);

  return Container(
    // margin: const EdgeInsets.only(top: 10),
    // width: MediaQuery.of(context).size.width -
    //     MediaQuery.of(context).size.width / 15,
    // height: 20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [datePicker(context, controller)],
        ),
        Container(
          padding: const EdgeInsets.only(top: 40),
          height: 350,
          child: SingleChildScrollView(
              child: Column(
            children: controller.calendar
                .map((item) => TextButton(
                    onPressed: () => controller.selectTime(item),
                    // onPressed: () => dateTimePicker(context, controller),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 50),
                        timeSection(context, item),
                        const SizedBox(width: 15),
                        slotsNumberSection(context, item),
                        const SizedBox(width: 15),
                        slotsNumberSection(context, item)
                      ],
                    )))
                .toList(),
          )),
        ),
      ],
    ),
  );
}

datePicker(context, controller) {
  return Container(
    margin: const EdgeInsets.only(left: 35),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Row(
            children: [
              IconButton(
                iconSize: 20.0,
                padding: const EdgeInsets.only(top: 10.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: highlight,
                ),
                onPressed: () => controller.prevDate(),
              ),
              TextButton(
                  onPressed: () => dateTimePicker(context, controller),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                                DateFormat('EEEE MMMM dd, yyyy')
                                    .format(controller.startDate),
                                style: const TextStyle(color: secondary)),
                          ),
                        ],
                      ),
                    ],
                  )),
              IconButton(
                iconSize: 20.0,
                padding: const EdgeInsets.only(top: 10.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: highlight,
                ),
                onPressed: () => controller.nextDate(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

dateTimePicker(context, controller) async {
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500.0,
                  maxWidth: 600.0,
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
  if (picked != null) {
    controller.pickDateRange(picked);
  }
}

timeSection(context, item) {
  return SizedBox(
    width: 120,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 80,
              child: Text('${item['time']['text']}',
                  style: const TextStyle(fontSize: 20.0, color: highlight)),
            ),
          ],
        ),
        const SizedBox(
          width: 200,
          height: 50,
          child: Divider(
            color: secondaryDim,
          ),
        )
      ],
    ),
  );
}

slotsNumberSection(context, item) {
  return const SizedBox(
    width: 120,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 80,
              child: Text('32 /55',
                  style: TextStyle(fontSize: 20.0, color: primary)),
            ),
          ],
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: Divider(
            color: secondaryDim,
          ),
        )
      ],
    ),
  );
}

slotsSection(context) {
  return const SizedBox(
    width: 120,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 80,
              child:
                  Text('4', style: TextStyle(fontSize: 20.0, color: primary)),
            ),
            SizedBox(
              width: 20,
              child: VerticalDivider(
                width: 10,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                color: secondary,
              ),
            )
          ],
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: Divider(
            color: secondaryDim,
          ),
        )
      ],
    ),
  );
}
