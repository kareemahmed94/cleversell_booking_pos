import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:cleversell_booking/ui/widgets/layouts/app_bar.dart';
import 'package:cleversell_booking/ui/widgets/layouts/drawer.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  Widget body;
  Color backgroundColor;
  bool showAppBar;
  bool showDrawer = false;
  GlobalKey<ScaffoldState>? scaffoldKey;

  Screen(
      {Key? key,
      required this.body,
      this.backgroundColor = background,
      this.scaffoldKey,
      this.showAppBar = false,
      this.showDrawer = false})
      : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();

    return Scaffold(
        // key: dataKey,
        drawer: Builder(
            builder: (context) =>
                widget.showDrawer ? drawerWidget(context) : const Center()),
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
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [widget.body],
              )
    );
  }
}
