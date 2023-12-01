
import 'package:cleversell_booking/ui/widgets/dashboard/wrapper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/constants/colors.dart';
import '../../../core/controller/dashboard_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/loader.dart';

Widget rooms(DashboardController controller, context) {
  return Center(
    child: controller.rooms.isNotEmpty
        ? Row(
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
                return wrapper(controller, context, controller.rooms[index]);
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
    )
        : const Center(child: Loader()),
  );
}
