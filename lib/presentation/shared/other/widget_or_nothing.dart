import 'package:flutter/material.dart';

/// Returns either a widget or nothing (a container), based on a bool.
class WidgetOrNothing extends StatelessWidget {
  const WidgetOrNothing({
    super.key,
    required this.showWidget,
    this.animatedTransition = true,
    required this.child,
  });

  final Widget child;
  final bool showWidget;
  final bool animatedTransition;

  @override
  Widget build(BuildContext context) {
    return animatedTransition
        ? AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: showWidget ? child : Container(),
          )
        : showWidget
            ? child
            : Container();
  }
}
