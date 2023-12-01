import 'dart:convert';

import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:cleversell_booking/ui/widgets/layouts/app_bar.dart';
import 'package:cleversell_booking/ui/widgets/layouts/drawer.dart';
import 'package:cleversell_booking/ui/widgets/layouts/footer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen extends StatefulWidget {
  Widget body;
  Color backgroundColor;
  bool showAppBar;
  bool showDrawer = false;
  GlobalKey<ScaffoldState>? scaffoldKey;
  Widget? footer;

  Screen(
      {Key? key,
      required this.body,
      this.backgroundColor = background,
      this.scaffoldKey,
      this.footer,
      this.showAppBar = false,
      this.showDrawer = false})
      : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  var staff;
  var printerStatus = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      var staffJson = prefs.getString("staff");
      staff = jsonDecode(staffJson!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();

    return Scaffold(
        // key: dataKey,
        // bottomNavigationBar: widget.footer ?? const Center(),
        drawer: Builder(
            builder: (context) => widget.showDrawer
                ? drawerWidget(context, staff)
                : const Center()),
        backgroundColor: widget.backgroundColor,
        body: Builder(
            builder: (context) => SafeArea(child: _bodyColumn(context)))); //,
  }

  Widget _bodyColumn(context) {
    return SingleChildScrollView(
        child: widget.showAppBar
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  appBar(context),
                  widget.body,
                  footer(context, staff, printerStatus)
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [widget.body],
              ));
  }
}
