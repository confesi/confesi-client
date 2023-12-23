import 'package:confesi/constants/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../button_touch_effects/touchable_scale.dart';

class CircleIconBtn extends StatelessWidget {
  const CircleIconBtn({
    Key? key,
    this.onTap,
    required this.icon,
    this.bgColor,
    this.color,
    this.disabled = false,
    this.isSelected = false,
    this.selectedColor,
    this.isBig = false,
    this.hasBorder = true,
  }) : super(key: key);

  final bool hasBorder;
  final bool isSelected;
  final VoidCallback? onTap; // Made it nullable
  final IconData icon;
  final Color? color;
  final Color? bgColor;
  final bool disabled;
  final Color? selectedColor;
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    Widget circleIconButton = AnimatedContainer(
      duration: const Duration(milliseconds: 75),
      padding: EdgeInsets.all(isBig ? 16 : 8),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: Theme.of(context).colorScheme.onBackground,
                width: borderSize,
                strokeAlign: BorderSide.strokeAlignInside,
              )
            : null,
      ),
      child: Icon(
        icon,
        color: isSelected
            ? selectedColor ?? Theme.of(context).colorScheme.secondary
            : color ?? Theme.of(context).colorScheme.primary,
      ),
    );

    return AbsorbPointer(
      absorbing: disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: onTap != null // Conditional check
            ? TouchableScale(
                onTap: disabled ? () {} : onTap!,
                child: circleIconButton,
              )
            : circleIconButton,
      ),
    );
  }
}
