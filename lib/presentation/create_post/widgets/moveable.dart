import 'package:flutter/material.dart';
import '../../shared/edited_source_widgets/matrix_gesture_detector.dart';

class Moveable extends StatefulWidget {
  final Matrix4 initialMatrix;
  final Widget child;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final Function(Matrix4 matrix) onMatrixChange; // new callback for matrix changes

  const Moveable({
    Key? key,
    required this.child,
    required this.onDragStart,
    required this.onDragEnd,
    required this.initialMatrix, // new parameter
    required this.onMatrixChange, // new parameter
  }) : super(key: key);

  @override
  MoveableState createState() => MoveableState();
}

class MoveableState extends State<Moveable> {
  late ValueNotifier<Matrix4> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.initialMatrix);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: MatrixGestureDetector(
        onScaleEnd: () {
          widget.onDragEnd();
        },
        onScaleStart: () {
          widget.onDragStart();
        },
        shouldTranslate: true,
        shouldScale: true,
        shouldRotate: true,
        onMatrixUpdate: (m, tm, sm, rm) {
          notifier.value = m;
          widget.onMatrixChange(m); // notify the parent of matrix changes
        },
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, _) {
            return Transform(
              transform: notifier.value,
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
