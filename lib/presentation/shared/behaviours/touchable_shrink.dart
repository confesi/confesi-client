import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchableShrink extends StatefulWidget {
  const TouchableShrink({
    super.key,
    required this.onLongPress,
    required this.child,
    this.growBackground,
    this.shrinkBackground,
  });

  final VoidCallback onLongPress;
  final Widget child;
  final VoidCallback? shrinkBackground;
  final VoidCallback? growBackground;

  @override
  State<TouchableShrink> createState() => _TouchableShrinkState();
}

class _TouchableShrinkState extends State<TouchableShrink>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
    );
    anim = CurvedAnimation(
        parent: animController,
        curve: Curves.linear,
        reverseCurve: Curves.linear);
    // _timer = Timer(const Duration(milliseconds: 100), callback);
    super.initState();
  }

  void startAnim() async {
    if (widget.shrinkBackground != null) widget.shrinkBackground!();
    animController.forward();
    animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    if (widget.growBackground != null) widget.growBackground!();
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
      onTapUp: (_) => reverseAnim(),
      onTapCancel: () => reverseAnim(),
      onTapDown: (_) => startAnim(),
      onLongPress: () {
        HapticFeedback.lightImpact();
        widget.onLongPress();
        reverseAnim();
      },
      child: Transform.scale(
        scale: -1 / 8 * anim.value + 1,
        child: widget.child,
      ),
    );
  }
}
