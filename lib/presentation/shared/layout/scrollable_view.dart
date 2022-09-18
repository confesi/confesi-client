import 'package:Confessi/presentation/shared/behaviours/overscroll.dart';
import 'package:flutter/cupertino.dart';

class ScrollableView extends StatelessWidget {
  const ScrollableView({
    this.horizontalPadding = 0.0,
    required this.child,
    this.physics,
    this.controller,
    this.keyboardDismiss = false,
    this.thumbVisible = true,
    Key? key,
  }) : super(key: key);

  final bool thumbVisible;
  final bool keyboardDismiss;
  final Widget child;
  final double horizontalPadding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (keyboardDismiss && notification.metrics.pixels < -15) {
          FocusScope.of(context).unfocus();
        }
        return true;
      },
      child: CupertinoScrollbar(
        thumbVisibility: thumbVisible,
        controller: controller,
        child: ScrollConfiguration(
          behavior: NoOverScrollSplash(),
          child: SingleChildScrollView(
            controller: controller,
            physics: physics,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
