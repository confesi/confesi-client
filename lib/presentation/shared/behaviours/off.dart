import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Off extends StatelessWidget {
  const Off({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Opacity(
        opacity: 0,
        child: child,
      ),
    );
  }
}
