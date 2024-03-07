import 'package:flutter/material.dart';

class Bobbing extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool rotate;

  const Bobbing({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.rotate = true,
  }) : super(key: key);

  @override
  BobbingState createState() => BobbingState();
}

class BobbingState extends State<Bobbing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _rotationAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    // set state to reflect changes
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double rotationValue = widget.rotate ? _rotationAnimation.value * 2 * 3.141592653589793 : 0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotationValue,
          child: widget.child,
        );
      },
    );
  }
}
