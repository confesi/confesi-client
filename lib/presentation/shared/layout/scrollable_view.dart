import 'package:Confessi/presentation/shared/behaviours/overscroll.dart';
import 'package:flutter/cupertino.dart';

class ScrollableView extends StatelessWidget {
  const ScrollableView({
    this.horizontalPadding = 0.0,
    required this.child,
    this.physics,
    this.controller,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double horizontalPadding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: controller,
      child: ScrollConfiguration(
        behavior: NoOverScrollSplash(),
        child: SingleChildScrollView(
          controller: controller,
          physics: physics,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
