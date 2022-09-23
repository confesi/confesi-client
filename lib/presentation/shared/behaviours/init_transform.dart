import 'package:flutter/material.dart';

enum TransformDirection {
  horizontal,
  vertical,
}

class InitTransform extends StatefulWidget {
  /// On [initState], makes the widget animate in from a certain side.
  const InitTransform({
    super.key,
    required this.child,
    this.magnitudeOfTransform = 100,
    this.transformDirection = TransformDirection.vertical,
  });

  final Widget child;
  final double magnitudeOfTransform;
  final TransformDirection transformDirection;

  @override
  State<InitTransform> createState() => InitTransformState();
}

class InitTransformState extends State<InitTransform>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    );
    startAnim();
    super.initState();
  }

  void startAnim() async {
    _animController.forward();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double offSet() => (widget.magnitudeOfTransform -
          (_anim.value * widget.magnitudeOfTransform))
      .toDouble();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        widget.transformDirection == TransformDirection.horizontal
            ? offSet()
            : 0,
        widget.transformDirection == TransformDirection.vertical ? offSet() : 0,
      ),
      child: widget.child,
    );
  }
}
