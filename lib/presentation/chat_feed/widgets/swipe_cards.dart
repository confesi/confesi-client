import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math" as math;

class SwipeCardsController extends ChangeNotifier {}

// todo: if position is top, shrink it a bit?
// todo: only allow drag if top index (0) of stack

class SwipeCards extends StatefulWidget {
  const SwipeCards({
    super.key,
    required this.controller,
  });

  final SwipeCardsController controller;

  @override
  State<SwipeCards> createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _DraggableWrapper(),
      ],
    );
  }
}

class _DraggableWrapper extends StatefulWidget {
  const _DraggableWrapper({super.key});

  @override
  State<_DraggableWrapper> createState() => _DraggableWrapperState();
}

class _DraggableWrapperState extends State<_DraggableWrapper> with SingleTickerProviderStateMixin {
  late Offset offset = const Offset(0, 0);
  bool animateBackToStart = false;

  late AnimationController rotationController;
  late Animation rotationAnim;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   offset = Offset(widthFraction(context, 1 / 4), 0);
  //   super.didChangeDependencies();
  // }

  double getRotation(double dx) {
    double rotOffset = dx / 100;
    int multiplier = rotOffset < 0 ? -1 : 1;
    return multiplier * numberUntilLimit(rotOffset.abs(), 2) * math.pi / 16;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => setState(() => animateBackToStart = false),
      onPanUpdate: (details) =>
          setState(() => offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy)),
      onPanEnd: (details) => setState(() {
        offset = const Offset(0, 0);
        animateBackToStart = true;
        HapticFeedback.lightImpact();
      }),
      child: Container(
        color: Colors.blue,
        height: 400,
        width: widthFraction(context, .8),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: animateBackToStart ? const Duration(milliseconds: 800) : Duration.zero,
              curve: Curves.easeOutBack,
              left: offset.dx,
              // right: offset.dx,
              top: offset.dy,
              // bottom: offset.dy,
              child: AnimatedContainer(
                duration: animateBackToStart ? const Duration(milliseconds: 800) : Duration.zero,
                transform: Matrix4.rotationZ(getRotation(offset.dx)),
                curve: Curves.easeOutBack,
                child: Transform.rotate(
                  // scale: offset.dy > 100 ? 1 : 1,
                  // angle: getRotation(offset.dx),
                  angle: 0,
                  child: Container(
                    height: 400,
                    color: Colors.red,
                    width: widthFraction(context, .8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
