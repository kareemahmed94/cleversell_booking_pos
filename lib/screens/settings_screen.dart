import '../core/controller/branch_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/colors.dart';
import '../core/controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController controller;

  const SettingsScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: controller,
        // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
        builder: (_) => _body(context));
  }

  Widget _body(context) {
    return Scaffold(
      backgroundColor: background,
      body: SizedBox(
          child: Scrollbar(
            thumbVisibility: false,
            child: ListView.builder(
                primary: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              height: 250,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/logo.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Text(
                              "WELCOME TO CLEVERSELL",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    _branches(context),
                                    const SizedBox(
                                      width: 700,
                                      height: 5,
                                      child: Divider(
                                        color: placeholder,
                                        thickness: 4,
                                      ),
                                    ),
                                    _environments(context)
                                  ],
                                )),
                            _form(context)
                          ],
                        )),
                  );
                }),
          )),
    );
  }

  Widget _branches(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _branchWidgets(context),
    );
  }

  List<Widget> _branchWidgets(context) {
    List<Widget> widgets = [];
    for (var x = 0; x < controller.branches.length; x++) {
      widgets.add(_wrapper(context, "branch", controller.branches[x],
          controller.selectedBranch == controller.branches[x].id));
    }
    return widgets;
  }

  Widget _environments(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _wrapper(
            context, "env", "DEVELOPMENT", controller.selectedEnv == "dev"),
        _wrapper(
            context, "env", "PRODUCTION", controller.selectedEnv == "prod"),
        _wrapper(context, "env", "CUSTOM", controller.selectedEnv == "custom"),
      ],
    );
  }

  Widget _wrapper(context, type, content, check) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 40, bottom: 30),
      width: 180,
      height: 90,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  if (check) {
                    return placeholder;
                  }
                  return background;
                }
                if (check) {
                  return background;
                }
                return placeholder;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: const BorderSide(
                      color: placeholder, width: 5, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(15.0),
                ))),
        onPressed: () => type == "branch"
            ? controller.selectBranch(content?.id)
            : controller.selectEnv(content),
        child: Text(type == "branch" ? content?.name : content,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: check ? highlight : primary)),
      ),
    );
  }

  Widget _form(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        controller.selectedEnv == "custom"
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 40),
              child: const Text(
                "SERVER IP",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 230,
              child: TextFormField(
                controller: controller.serverIp,
                style: const TextStyle(color: background),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  filled: true,
                  fillColor: primaryDim,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  labelText: 'Enter Server Ip',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Server Ip field is required';
                  }
                  return null;
                },
              ),
            )
          ],
        )
            : Container(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 38),
              child: const Text(
                "PRINTER IP",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 230,
              child: TextFormField(
                controller: controller.printerIp,
                style: const TextStyle(color: background),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  filled: true,
                  fillColor: primaryDim,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  labelText: 'Enter Printer Ip',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'PrinterIp field is required';
                  }
                  return null;
                },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _button(context, "restart", "RESTART"),
          ],
        )
      ],
    );
  }

  Widget _button(context, type, content) {
    return Container(
      margin: const EdgeInsets.only(top: 30, right: 50),
      width: 150,
      height: 70,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return null;
                }
                return highlight; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ))),
        onPressed: () {
          if (type == 'restart') {
            controller.login();
          } else {
            controller.logout();
          }
        },
        child: Text(content,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
