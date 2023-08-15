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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(() => setState(() {}));
    _controller.repeat(); // Remove reverse: true to make it spin in one direction
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double rotationValue = _controller.value * 2 * 3.141592653589793;

    double bobbingScale = 1.0;
    if (widget.bobbing) {
      // Adjust the bobbing scale based on the animation progress
      bobbingScale = 0.6 + 0.3 * (1 - (_controller.value * 2 - 1).abs());
    }

    Widget content = widget.child; // Default to original child

    if (widget.bobbing) {
      content = Transform.scale(
        scale: bobbingScale,
        child: content,
      );
    }

    if (widget.rotate && rotationValue != 0) {
      // Add optional rotation logic here
      content = Transform.rotate(
        angle: rotationValue,
        child: content,
      );
    }

    return content;
  }
}
