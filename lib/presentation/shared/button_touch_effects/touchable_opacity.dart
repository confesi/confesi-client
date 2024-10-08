import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/shared/enums.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    this.tappable = true,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.behavior = HitTestBehavior.opaque,
    this.tapType,
    Key? key,
  }) : super(key: key);

  final HitTestBehavior behavior;
  final Widget child;
  final Function onTap;
  final bool tappable;
  final TapType? tapType;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50), reverseDuration: const Duration(milliseconds: 500));
    anim = CurvedAnimation(parent: animController, curve: Curves.linear, reverseCurve: Curves.linear);
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void startAnim() async {
    animController.forward().then((value) => animController.reverse());
    animController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return widget.tappable
        ? GestureDetector(
            behavior: widget.behavior,
            onTapDown: (_) {
              animController.forward();
              animController.addListener(() => setState(() {}));
            },
            onLongPress: widget.onLongPress != null
                ? () {
                    if (widget.onLongPress != null) {
                      widget.onLongPress!();
                      HapticFeedback.lightImpact();
                    }
                  }
                : null,
            onDoubleTap: widget.onDoubleTap, // Pass onDoubleTap callback
            onTapCancel: () {
              animController.reverse();
              animController.addListener(() => setState(() {}));
            },
            onTap: () {
              widget.onTap();
              if (widget.tapType != null) {
                if (widget.tapType == TapType.lightImpact) {
                  HapticFeedback.lightImpact();
                } else if (widget.tapType == TapType.strongImpact) {
                  HapticFeedback.heavyImpact();
                }
              }
              startAnim();
            },
            child: Opacity(
              opacity: -anim.value * 0.9 + 1,
              child: widget.child,
            ),
          )
        : widget.child;
  }
}
