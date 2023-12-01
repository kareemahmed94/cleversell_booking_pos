import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatefulWidget {
  final List<Color>? colors;

  const Loader({super.key, this.colors});

  @override
  State<Loader> createState() => _LoaderState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _LoaderState extends State<Loader> {


  @override
  Widget build(BuildContext context) {
    final List<Color> kDefaultRainbowColors = widget.colors ?? [
      highlight,
      Colors.orange,
    ];
    return Center(
      child: SizedBox(
        width: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: kDefaultRainbowColors,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
