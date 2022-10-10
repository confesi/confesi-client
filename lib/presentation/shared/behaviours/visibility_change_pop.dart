import 'dart:math';

import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VisibilityScale extends StatefulWidget {
  const VisibilityScale({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<VisibilityScale> createState() => _VisibilityScaleState();
}

class _VisibilityScaleState extends State<VisibilityScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;
  late double randomAngle;

  @override
  void initState() {
    _animController = AnimationController(
      value: 1,
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    );
    randomAngle = Random().nextDouble();
    super.initState();
  }

  void reverseAnim() async {
    _animController.reverse();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: VisibilityDetector(
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0) reverseAnim();
        },
        key: UniqueKey(),
        child: Opacity(
          opacity: (1 - _anim.value * randomAngle).toDouble(),
          child: Transform.scale(
            scale: (1 - _anim.value / 2).toDouble(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
