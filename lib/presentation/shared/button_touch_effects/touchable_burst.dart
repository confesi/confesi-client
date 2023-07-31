import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchableBurst extends StatefulWidget {
  const TouchableBurst({
    required this.child,
    required this.onTap,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<TouchableBurst> createState() => _TouchableBurstState();
}

class _TouchableBurstState extends State<TouchableBurst> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0), reverseDuration: const Duration(milliseconds: 200));
    anim = CurvedAnimation(parent: animController, curve: Curves.decelerate, reverseCurve: Curves.decelerate);
  }

  void startAnim() async {
    animController.forward().then((value) async {
      animController.reverse();
    });
    animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    animController.reverse();
    animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        startAnim();
        widget.onTap();
      },
      child: Transform.scale(
        scale: anim.value / 50 + 1,
        child: Opacity(
          opacity: -anim.value * 0.3 + 1,
          child: widget.child,
        ),
      ),
    );
  }
}
