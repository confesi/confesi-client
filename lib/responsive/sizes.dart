import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Responsive extends StatelessWidget {
  late Widget mobile;
  late Widget tablet;
  late Widget desktop;

  Responsive(this.mobile, Widget? tablet, Widget? desktop, {Key? key}) : super(key: key) {
    if (tablet == null) {
      this.tablet = mobile;
    } else {
      this.tablet = tablet;
    }
    if (desktop == null) {
      this.desktop = mobile;
    } else {
      this.desktop = desktop;
    }
  }

  // const Responsive({
  //   Key? key,
  //   required this.mobile,
  //   required this.tablet,
  //   required this.desktop,
  // }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        }
        // If width it less then 1100 and more then 650 we consider it as tablet
        else if (constraints.maxWidth >= 650) {
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
