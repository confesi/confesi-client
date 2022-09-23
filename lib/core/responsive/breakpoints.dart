import 'package:flutter/material.dart';

import '../../constants/shared/general.dart';

// ignore: must_be_immutable
class Responsive extends StatelessWidget {
  final Widget mobile;
  late Widget tablet;

  /// Widget that lets you have a [mobile] child and [tablet] child.
  ///
  /// When the screen size changes, depending on the size, only the [mobile] or [tablet]
  /// child will be rendered.
  Responsive(this.mobile, Widget? tablet, {Key? key}) : super(key: key) {
    if (tablet == null) {
      this.tablet = mobile;
    } else {
      this.tablet = tablet;
    }
  }

  /// Getter to check if the device is a mobile.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < kTabletBreakpoint;

  /// Getter to check if the device is a mobile.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= kTabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width is greater than 650, we consider it as tablet.
        if (constraints.maxWidth >= kTabletBreakpoint) {
          return tablet;
        }
        // Or less then that, it's a mobile.
        else {
          return mobile;
        }
      },
    );
  }
}
