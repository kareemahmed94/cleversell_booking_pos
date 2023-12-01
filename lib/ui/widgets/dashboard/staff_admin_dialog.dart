import 'package:cleversell_booking/core/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../common/loader.dart';

Future<String?> staffAdminDialog(DashboardController controller, context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: surface,
      title: const Text(
        'Please Confirm Admin Credentials',
        style: TextStyle(color: primary),
      ),
      content: Container(
        height: 250,
        child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 120,
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                _username(controller, context),
                const SizedBox(
                  height: 20,
                ),
                _password(controller, context),
                _loginBtn(controller, context)
              ],
            )),
      ),
    ),
  );
}

Widget _username(DashboardController controller, context) {
  return SizedBox(
    width: 200,
    height: 40,
    child: TextFormField(
      // focusNode: controller.focusNode,
      keyboardType: TextInputType.number,
      controller: controller.staffId,
      style: const TextStyle(color: background),
      decoration: InputDecoration(
        filled: true,
        fillColor: primaryDim,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: 'Type Your ID Here',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Staff ID field is required';
        }
        return null;
      },
    ),
  );
}

Widget _password(DashboardController controller, context) {
  return SizedBox(
    width: 200,
    height: 40,
    child: TextFormField(
      // focusNode: controller.focusNode,
      controller: controller.password,
      style: const TextStyle(color: background),
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: primaryDim,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: 'Type Your Password Here',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password field is required';
        }
        return null;
      },
    ),
  );
}

Widget _loginBtn(DashboardController controller, context) {
  final List<Color> loaderColors = [
    Colors.black,
  ];
  return Container(
    margin: const EdgeInsets.only(top: 30),
    width: 150,
    height: 60,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return null;
              }
              return success;
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ))),
      onPressed: () => controller.confirmStaffAdmin(context),
      child: controller.loading
          ? Loader(colors: loaderColors)
          : const Text("Confirm",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400)),
    ),
  );
}
