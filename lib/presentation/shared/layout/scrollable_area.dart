import 'package:Confessi/presentation/shared/behaviours/overscroll.dart';
import 'package:flutter/cupertino.dart';

class ScrollableArea extends StatefulWidget {
  const ScrollableArea({
    this.horizontalPadding = 0.0,
    required this.child,
    this.physics,
    this.controller,
    this.keyboardDismiss = false,
    this.thumbVisible = true,
    this.scrollDirection = Axis.vertical,
    this.bubbleUpScrollNotifications = true,
    Key? key,
  }) : super(key: key);

  final bool thumbVisible;
  final bool keyboardDismiss;
  final Widget child;
  final double horizontalPadding;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final ScrollController? controller;
  final bool bubbleUpScrollNotifications;

  @override
  State<ScrollableArea> createState() => _ScrollableAreaState();
}

class _ScrollableAreaState extends State<ScrollableArea> {
  ScrollNotification? _lastScrollNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification &&
            (_lastScrollNotification == null || _lastScrollNotification is ScrollStartNotification)) {
          FocusScope.of(context).unfocus();
        }
        _lastScrollNotification = notification;
        return !widget.bubbleUpScrollNotifications;
      },
      child: CupertinoScrollbar(
        thickness: widget.thumbVisible ? 3.0 : 0.0,
        thumbVisibility: widget.thumbVisible ? null : false,
        controller: widget.controller,
        child: ScrollConfiguration(
          behavior: NoOverScrollSplash(),
          child: SingleChildScrollView(
            scrollDirection: widget.scrollDirection,
            controller: widget.controller,
            physics: widget.physics,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
