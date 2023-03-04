import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:flutter/material.dart';

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
        _Card(),
      ],
    );
  }
}

class _Card extends StatefulWidget {
  const _Card({super.key});

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> with SingleTickerProviderStateMixin {
  Offset offset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: Container(
        height: 300,
        color: Colors.red,
        width: 200,
      ),
      childWhenDragging: Container(),
      onDragUpdate: (details) {
        print(details);
        setState(() => offset = details.delta);
      },
      // onDragCompleted: () => setState(() => offset = const Offset(0, 0)),
      onDragEnd: (details) {
        if (details.offset.dx.abs() > widthFraction(context, .1)) {
          if (details.offset.dx > 0) {
            // _onSwipeRight();
            print("RIGHT");
          } else {
            // _onSwipeLeft();
            print("LEFT");
          }
        }
      },
      child: Transform.scale(
        scale: 1,
        child: Container(
          height: 300,
          color: Colors.red,
          width: 200,
        ),
      ),
    );
  }
}
