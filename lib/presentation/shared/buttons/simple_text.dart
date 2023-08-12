import '../button_touch_effects/touchable_scale.dart';

import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/styles/typography.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onTap,
    required this.text,
    this.isErrorText = false,
    this.tapType = TapType.none,
    this.infiniteWidth = false,
    this.horizontalPadding = 0,
    this.secondaryColors = false,
    this.thirdColors = false,
    this.bgColor,
    this.textColor,
    this.maxLines = 1,
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  final Color? bgColor;
  final Color? textColor;
  final int maxLines;
  final bool secondaryColors;
  final bool thirdColors;
  final double horizontalPadding;
  final Function onTap;
  final String text;
  final bool isErrorText;
  final TapType tapType;
  final bool infiniteWidth;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: TouchableScale(
          tapType: tapType,
          onTap: () => onTap(),
          child: AnimatedContainer(
            key: UniqueKey(),
            margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
            duration: const Duration(milliseconds: 175),
            width: infiniteWidth ? double.infinity : null,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.8,
                  strokeAlign: BorderSide.strokeAlignInside),
              color: bgColor ??
                  (secondaryColors
                      ? Theme.of(context).colorScheme.secondary
                      : thirdColors
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).colorScheme.surface),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
              style: kTitle.copyWith(
                color: textColor ??
                    (isErrorText
                        ? Theme.of(context).colorScheme.error
                        : secondaryColors
                            ? Theme.of(context).colorScheme.onSecondary
                            : thirdColors
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
