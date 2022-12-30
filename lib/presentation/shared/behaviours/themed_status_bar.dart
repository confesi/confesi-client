import '../../../core/utils/sizing/width_fraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemedStatusBar extends StatelessWidget {
  const ThemedStatusBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: child,
    );
  }
}
