import 'package:cleversell_booking/core/controller/staff_auth_controller.dart';
import 'package:cleversell_booking/ui/widgets/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../core/constants/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StaffAuthScreen extends StatelessWidget {
  final StaffAuthController controller;

  const StaffAuthScreen(this.controller, {super.key});

  static const List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffAuthController>(
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
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.width / 4,
                      margin: const EdgeInsets.only(top: 40, bottom: 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo2.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      "WELCOME BACK, PLEASE LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Center(),
                    ),
                    _username(context),
                    const SizedBox(
                      height: 20,
                    ),
                    _password(context),
                    _loginBtn(context)
                  ],
                )),
              );
            }),
      )),
    );
  }

  Widget _staffSlider(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => controller.prev(),
          // style: _scrollButtonStyle,
          child: const Icon(
            Icons.arrow_back_ios,
            color: highlight,
            size: 60.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 4.5,
          child: ScrollablePositionedList.builder(
              itemCount: controller.staff.length,
              itemBuilder: (context, index) {
                return _wrapper(
                    context,
                    controller.staff[index],
                    controller.staff[index]?.id == controller.selectedStaff.id);
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
            size: 60.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ),
      ],
    );
  }

  Widget _wrapper(context, staff, check) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 40, bottom: 30),
      width: MediaQuery.of(context).size.width / 10,
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
                  color: placeholder, width: 3, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () => controller.selectStaff(staff),
        child: Text("${staff?.name}",
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color: check ? highlight : primary)),
      ),
    );
  }

  Widget _username(context) {
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
  Widget _password(context) {
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
  Widget _loginBtn(context) {
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
        onPressed: () => controller.login(),
        child: controller.loading ? Loader(colors: loaderColors)
        //     ? CircularProgressIndicator(
        //   value: controller.animationController?.value,
        //   semanticsLabel: 'Circular progress indicator',
        //   color: background,
        // )
            : const Text("Login",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400)),
      ),
    );
  }

}
