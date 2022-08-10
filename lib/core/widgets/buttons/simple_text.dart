import 'package:flutter/material.dart';

import '../../constants/buttons.dart';
import '../../styles/typography.dart';
import 'touchable_opacity.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onTap,
    required this.text,
    this.tooltip,
    this.isErrorText = false,
    this.tooltipLocation,
    Key? key,
  }) : super(key: key);

  final Function onTap;
  final String? tooltip;
  final String text;
  final bool isErrorText;
  final TooltipLocation? tooltipLocation;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tapType: TapType.strongImpact,
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
          textAlign: TextAlign.right,
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
