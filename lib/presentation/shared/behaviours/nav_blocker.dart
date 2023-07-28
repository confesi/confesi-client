import 'package:back_button_interceptor/back_button_interceptor.dart';
import '../../../core/router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

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
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
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
    return WillPopScope(
      onWillPop: widget.blocking ? () => Future.value(false) : null,
      child: widget.child,
    );
  }
}
