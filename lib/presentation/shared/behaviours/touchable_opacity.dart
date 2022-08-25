import 'package:Confessi/constants/shared/buttons.dart';
import 'package:Confessi/presentation/shared/behaviours/tool_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    this.tappable = true,
    required this.child,
    required this.onTap,
    this.tooltip,
    this.tapType,
    this.tooltipLocation,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function onTap;
  final bool tappable;
  final String? tooltip;
  final TapType? tapType;
  final TooltipLocation? tooltipLocation;

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 0),
        reverseDuration: const Duration(milliseconds: 400));
    anim = CurvedAnimation(
        parent: animController,
        curve: Curves.linear,
        reverseCurve: Curves.linear);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return ToolTip(
      tooltipLocation: widget.tooltipLocation,
      message: widget.tooltip,
      child: widget.tappable
          ? GestureDetector(
              onTapDown: (_) => setState(() {
                animController.forward();
                animController.addListener(() {
                  setState(() {});
                });
              }),
              onTapCancel: () => setState(() {
                animController.reverse();
                animController.addListener(() {
                  setState(() {});
                });
              }),
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
                opacity: -anim.value * 0.8 + 1,
                child: widget.child,
              ),
            )
          : widget.child,
    );
  }
}
