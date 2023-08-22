import 'package:flutter/material.dart';
import '../../shared/edited_source_widgets/matrix_gesture_detector.dart';

class Moveable extends StatelessWidget {
  Moveable({
    Key? key,
    required this.child,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onDragUpdate,
  }) : super(key: key);

  final Widget child;
  final Function(Offset offset) onDragStart;
  final Function(Offset offset) onDragEnd;
  final Function(Offset offset) onDragUpdate;

  final Offset offset = Offset.zero;

  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: MatrixGestureDetector(
        shouldTranslate: true,
        shouldScale: true,
        shouldRotate: true,
        onMatrixUpdate: (m, tm, sm, rm) => notifier.value = m,
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, _) {
            return Transform(
              transform: notifier.value,
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
