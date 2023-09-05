import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchableDelete extends StatefulWidget {
  const TouchableDelete({
    Key? key,
    this.onLongPress,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onLongPress;
  final Widget child;

  @override
  TouchableDeleteState createState() => TouchableDeleteState();
}

class TouchableDeleteState extends State<TouchableDelete> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

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

  void startAnim() {
    animController.forward();
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
    final errorColor = Theme.of(context).colorScheme.error;

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
      child: Transform.scale(
        scale: -1 / 8 * anim.value + 1,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            errorColor.withOpacity(anim.value),
            BlendMode.srcATop,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
