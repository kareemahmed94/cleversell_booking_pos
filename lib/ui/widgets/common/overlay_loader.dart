
import 'package:cleversell_booking/ui/widgets/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoaderOverlay extends StatefulWidget {
  final Widget body;

  const LoaderOverlay(this.body,{super.key});

  @override
  State<LoaderOverlay> createState() => _LoaderOverlayState();
}

class _LoaderOverlayState extends State<LoaderOverlay> {

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: Loader(),
      ),
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      duration: const Duration(seconds: 5),
      child: widget.body,
    );
  }
}