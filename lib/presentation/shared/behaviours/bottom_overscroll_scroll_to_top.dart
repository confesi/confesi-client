import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class BottomOverscrollScrollToTop extends StatefulWidget {
  const BottomOverscrollScrollToTop({
    required this.child,
    required this.scrollController,
    super.key,
  });

  final Widget child;
  final ScrollController scrollController;

  @override
  State<BottomOverscrollScrollToTop> createState() =>
      _BottomOverscrollScrollToTopState();
}

class _BottomOverscrollScrollToTopState
    extends State<BottomOverscrollScrollToTop> {
  double overscrollValue = 0.0;

  bool isAnimatingScroll = false;
  bool atBottom = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (details) {
        if (details.metrics.pixels >= details.metrics.maxScrollExtent) {
          setState(() {
            overscrollValue =
                details.metrics.pixels - details.metrics.maxScrollExtent;
          });
        } else {
          atBottom = false;
        }
        if (details.metrics.pixels >= details.metrics.maxScrollExtent) {
          atBottom = true;
        }
        if (overscrollValue > 175 && !isAnimatingScroll && atBottom) {
          isAnimatingScroll = true;
          widget.scrollController
              .animateTo(0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.decelerate)
              .then((value) {
            setState(() {
              overscrollValue = 0;
              isAnimatingScroll = false;
            });
          });
        }

        return false;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.child,
          ShakeWidget(
            autoPlay: overscrollValue > 125 ? true : false,
            shakeConstant: ShakeDefaultConstant2(),
            child: Transform.translate(
              offset: Offset(0, -overscrollValue * 2 + 175),
              child: Opacity(
                opacity: isAnimatingScroll
                    ? 0
                    : numberUntilLimit(overscrollValue / 100, 1),
                child: Transform.scale(
                  scale: numberUntilLimit(overscrollValue / 200, 1),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle),
                    width: 100,
                    height: 100,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          CupertinoIcons.arrow_up_to_line,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
