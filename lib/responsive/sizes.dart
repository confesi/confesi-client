import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/general.dart';

// ignore: must_be_immutable
class Responsive extends StatelessWidget {
  final Widget mobile;
  late Widget tablet;

  Responsive(this.mobile, Widget? tablet, {Key? key}) : super(key: key) {
    if (tablet == null) {
      this.tablet = mobile;
    } else {
      this.tablet = tablet;
    }
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < kTabletBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < kTabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width it less then 1100 and more then 650 we consider it as tablet
        if (constraints.maxWidth >= kTabletBreakpoint) {
          return tablet;
        }
        // Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
  }
}
