import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _LoaderState extends State<Loader> {
  final List<Color> _kDefaultRainbowColors = [
    highlight,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: _kDefaultRainbowColors,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
