import 'package:flutter/material.dart';

class Bobbing extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool rotate;
  final bool bobbing;

  const Bobbing({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.rotate = true,
    this.bobbing = true,
  }) : super(key: key);

  @override
  BobbingState createState() => BobbingState();
}

class BobbingState extends State<Bobbing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double rotationValue = _animation.value * 2 * 3.141592653589793;

        double bobbingScale = 1.0;
        if (widget.bobbing) {
          bobbingScale = 0.6 + 0.3 * (1 - (_animation.value * 2 - 1).abs());
        }

        Widget content = widget.child; // default to original child

        if (widget.bobbing) {
          content = Transform.scale(
            scale: bobbingScale,
            child: content,
          );
        }

        if (widget.rotate && rotationValue != 0) {
          content = Transform.rotate(
            angle: rotationValue,
            child: Transform.scale(
              scale: 0.70,
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }
}
