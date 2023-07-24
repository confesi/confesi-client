import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class AnimatedSimpleTextButton extends StatelessWidget {
  const AnimatedSimpleTextButton({
    required this.onTap,
    required this.text,
    this.isErrorText = false,
    this.tooltipLocation,
    this.tapType = TapType.none,
    this.useSecondaryColors = false,
    Key? key,
  }) : super(key: key);

  final bool useSecondaryColors;
  final Function onTap;
  final String text;
  final bool isErrorText;
  final TooltipLocation? tooltipLocation;
  final TapType tapType;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tapType: tapType,
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: useSecondaryColors ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: AnimatedSize(
          clipBehavior: Clip.antiAlias,
          duration: const Duration(milliseconds: 250),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> anim) => ScaleTransition(
                    scale: anim,
                    child: child,
                  ),
                  child: Text(
                    text,
                    key: ValueKey(text),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kTitle.copyWith(
                      color: isErrorText
                          ? Theme.of(context).colorScheme.error
                          : useSecondaryColors
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
