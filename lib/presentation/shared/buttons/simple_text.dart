import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onTap,
    required this.text,
    this.tooltip,
    this.isErrorText = false,
    this.tooltipLocation,
    this.tapType = TapType.none,
    this.infiniteWidth = false,
    this.horizontalPadding = 0,
    this.secondaryColors = false,
    this.thirdColors = false,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  final int maxLines;
  final bool secondaryColors;
  final bool thirdColors;
  final double horizontalPadding;
  final Function onTap;
  final String? tooltip;
  final String text;
  final bool isErrorText;
  final TooltipLocation? tooltipLocation;
  final TapType tapType;
  final bool infiniteWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TouchableOpacity(
        tapType: tapType,
        tooltip: tooltip,
        tooltipLocation: tooltipLocation,
        onTap: () => onTap(),
        child: Container(
          width: infiniteWidth ? double.infinity : null,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: secondaryColors
                ? Theme.of(context).colorScheme.secondary
                : thirdColors
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: kBody.copyWith(
              color: isErrorText
                  ? Theme.of(context).colorScheme.error
                  : secondaryColors
                      ? Theme.of(context).colorScheme.onSecondary
                      : thirdColors
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
