import 'package:flutter/material.dart';

class Bobbing extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool rotate; // New optional parameter

  const Bobbing({Key? key, required this.child, this.duration = const Duration(milliseconds: 1200), this.rotate = true})
      : super(key: key);

  @override
  BobbingState createState() => BobbingState();
}

class BobbingState extends State<Bobbing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tween = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.75, end: 1.0).chain(CurveTween(curve: Curves.decelerate)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.75).chain(CurveTween(curve: Curves.decelerate)), weight: 1),
    ]);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget content = Transform.scale(
          scale: tween.evaluate(_controller),
          child: widget.child,
        );

        if (widget.rotate) {
          // Add optional rotation logic here
          content = Transform.rotate(
            angle: _controller.value * 2 * 3.141592653589793, // Apply rotation without easing
            child: content,
          );
        }

        return content;
      },
    );
  }
}
