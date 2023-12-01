import 'package:cleversell_booking/core/controller/company_auth_controller.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/controller/splash_controller.dart';
import 'package:get/get.dart';

import '../ui/widgets/common/loader.dart';

class CompanyAuthScreen extends StatelessWidget {
  final CompanyAuthController controller;

  const CompanyAuthScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyAuthController>(
        init: controller,
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (_) => _body(context));
  }

  Widget _body(context) {
    return Scaffold(
        backgroundColor: background,
        body: Center(
            child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                margin: const EdgeInsets.only(bottom: 50, right: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 100,
                height: 400,
                child: VerticalDivider(
                  width: 30,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  color: Colors.white,
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      child: const Text(
                        "WELCOME TO CLEVERSELL",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          _name(context),
                          const SizedBox(
                            height: 30,
                          ),
                          _pin(context),
                          _loginBtn(context)
                        ],
                      ),
                    )
                  ])
            ],
          ),
        )));
  }

  Widget _name(context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 100),
          child: const Text(
            "Name",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: controller.username,
            style: const TextStyle(color: background),
            decoration: InputDecoration(
              filled: true,
              fillColor: primaryDim,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _pin(context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 115),
          child: const Text(
            "Pin",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: controller.pin,
            style: const TextStyle(color: background),
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: primaryDim,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: 'Pin',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pin field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _loginBtn(context) {
    final List<Color> loaderColors = [
      Colors.black,
    ];
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: 150,
      height: 70,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return null;
                }
                return primaryDim; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ))),
        onPressed: () => controller.login(context),
        // onPressed: () => controller.testPrinter(),
        child: controller.loading
            ? Loader(colors: loaderColors)
            : const Text("Enter",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400)),
      ),
    );
  }
}
