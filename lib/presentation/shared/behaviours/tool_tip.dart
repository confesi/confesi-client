import 'package:flutter/material.dart';

import '../../../core/constants/shared/buttons.dart';
import '../../../core/styles/typography.dart';

class ToolTip extends StatelessWidget {
  const ToolTip({
    this.tooltipLocation = TooltipLocation.above,
    required this.child,
    required this.message,
    Key? key,
  }) : super(key: key);

  final String? message;
  final Widget child;
  final TooltipLocation? tooltipLocation;

  @override
  Widget build(BuildContext context) {
    return message == null
        ? child
        : SafeArea(
            child: Tooltip(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              preferBelow: tooltipLocation != null &&
                      tooltipLocation == TooltipLocation.above
                  ? false
                  : true,
              triggerMode: TooltipTriggerMode.longPress,
              enableFeedback: true,
              textStyle: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    offset: const Offset(0, 0),
                    blurRadius: 80,
                  ),
                ],
              ),
              message: message,
              child: child,
            ),
          );
  }
}
