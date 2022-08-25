import 'package:flutter/material.dart';

import '../../../constants/shared/buttons.dart';
import '../../../core/styles/typography.dart';
import '../behaviours/touchable_opacity.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onTap,
    required this.text,
    this.tooltip,
    this.isErrorText = false,
    this.tooltipLocation,
    this.tapType = TapType.none,
    Key? key,
  }) : super(key: key);

  final Function onTap;
  final String? tooltip;
  final String text;
  final bool isErrorText;
  final TooltipLocation? tooltipLocation;
  final TapType tapType;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tapType: tapType,
      tooltip: tooltip,
      tooltipLocation: tooltipLocation,
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: kBody.copyWith(
            color: isErrorText
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
