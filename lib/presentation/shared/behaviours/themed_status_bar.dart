import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeStatusBar extends StatelessWidget {
  const ThemeStatusBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Center(
        child: child,
      ),
    );
  }
}
