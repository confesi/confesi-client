import 'package:flutter/material.dart';

class NavBlocker extends StatelessWidget {
  const NavBlocker({
    super.key,
    required this.blocking,
    required this.child,
  });

  final bool blocking;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return blocking
        ? WillPopScope(
            onWillPop: () async => false,
            child: child,
          )
        : child;
  }
}
