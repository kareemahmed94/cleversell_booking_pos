import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';


Widget wrapper(DashboardController controller, context, room) {
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
