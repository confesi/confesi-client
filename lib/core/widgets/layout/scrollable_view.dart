import 'package:Confessi/core/widgets/behaviours/overscroll.dart';
import 'package:flutter/cupertino.dart';

class ScrollableView extends StatelessWidget {
  const ScrollableView({
    this.horizontalPadding = 0.0,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ScrollConfiguration(
        behavior: NoOverScrollSplash(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
