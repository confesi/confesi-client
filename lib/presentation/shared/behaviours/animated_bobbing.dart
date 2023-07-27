import 'package:flutter/material.dart';

class Bobbing extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const Bobbing({Key? key, required this.child, this.duration = const Duration(milliseconds: 1500)}) : super(key: key);

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
      TweenSequenceItem(tween: Tween(begin: 0.75, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.75), weight: 1),
    ]);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: tween.evaluate(_controller),
          child: widget.child,
        );
      },
    );
  }
}
