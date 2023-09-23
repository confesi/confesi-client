import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class TouchableHighlight extends StatefulWidget {
  const TouchableHighlight({
    Key? key,
    this.onLongPress,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onLongPress;
  final Widget child;

  @override
  TouchableHighlightState createState() => TouchableHighlightState();
}

class TouchableHighlightState extends State<TouchableHighlight> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> anim;

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
    );

    anim = CurvedAnimation(
      parent: animController,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );
  }

  bool isAnimating = false;

  void startAnim() {
    setState(() => isAnimating = true);
    animController.forward();
  }

  void reverseAnim() {
    setState(() => isAnimating = false);
    animController.reverse();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onLongPress == null) {
      return widget.child; // Return the child directly without any touch effects
    }

    return GestureDetector(
      onTapUp: (_) => reverseAnim(),
      onTapCancel: reverseAnim,
      onTapDown: (_) => startAnim(),
      onLongPress: () {
        HapticFeedback.lightImpact();
        widget.onLongPress!();
        reverseAnim();
      },
      child: AnimatedBuilder(
        animation: anim,
        builder: (context, child) {
          return ShakeWidget(
            duration: const Duration(milliseconds: 500), // Fixed duration
            shakeConstant:
                ShakeLittleConstant1(), // Constants are usually not callable, remove parentheses if it's a property
            autoPlay: isAnimating,
            enableWebMouseHover: true,
            child: Transform.scale(
              scale: (1 - anim.value * 0.125)
                  .clamp(0.0, 1.0), // Clamping the scale value to prevent it from going negative
              child: Opacity(
                opacity: 1 - anim.value * 0.75,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
