import 'package:Confessi/presentation/shared/behaviours/tool_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/shared/enums.dart';

class TouchableScale extends StatefulWidget {
  const TouchableScale({
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
  State<TouchableScale> createState() => _TouchableScaleState();
}

class _TouchableScaleState extends State<TouchableScale> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100), reverseDuration: const Duration(milliseconds: 100));
    anim = CurvedAnimation(parent: animController, curve: Curves.linear, reverseCurve: Curves.linear);
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void executeTapType() {
    if (widget.tapType != null) {
      if (widget.tapType == TapType.lightImpact) {
        HapticFeedback.selectionClick();
      } else if (widget.tapType == TapType.strongImpact) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolTip(
      tooltipLocation: widget.tooltipLocation,
      message: widget.tooltip,
      child: widget.tappable
          ? GestureDetector(
              onTapDown: (_) {
                animController.forward();
                animController.addListener(() => setState(() {}));
              },
              onTapCancel: () {
                animController.reverse();
                animController.addListener(() => setState(() {}));
              },
              onTap: () {
                widget.onTap();
                executeTapType();
                animController.forward().then((_) => animController.reverse());
                animController.addListener(() => setState(() {}));
              },
              child: Transform.scale(
                scale: -anim.value * 0.2 + 1,
                child: widget.child,
              ),
            )
          : widget.child,
    );
  }
}