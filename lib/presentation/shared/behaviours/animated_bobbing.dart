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
  late Animation<double> _rotationAnimation;
  late Animation<double> _bobbingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
    _rotationAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _bobbingAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _bobbingAnimation]),
      builder: (context, child) {
        final double rotationValue = widget.rotate ? _rotationAnimation.value * 2 * 3.141592653589793 : 0;
        final double bobbingScale = widget.bobbing ? (0.6 + 0.3 * (1 - (_bobbingAnimation.value * 2 - 1).abs())) : 1.0;

        return Transform.rotate(
          angle: rotationValue,
          child: Transform.scale(
            scale: bobbingScale - 0.2,
            child: widget.child,
          ),
        );
      },
    );
  }
}
