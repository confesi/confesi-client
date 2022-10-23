import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

class NavBlocker extends StatefulWidget {
  const NavBlocker({
    super.key,
    required this.blocking,
    required this.child,
  });

  final bool blocking;
  final Widget child;

  @override
  State<NavBlocker> createState() => _NavBlockerState();
}

class _NavBlockerState extends State<NavBlocker> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return widget.blocking;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
