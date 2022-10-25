import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OneThemeStatusBar extends StatelessWidget {
  const OneThemeStatusBar({
    super.key,
    required this.child,
    required this.brightness,
  });

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: child,
    );
  }
}
