import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/utils/numbers/large_number_formatter.dart';

class VoteTile extends StatelessWidget {
  const VoteTile({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.tooltip,
    this.tooltipLocation,
    required this.value,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String? tooltip;
  final TooltipLocation? tooltipLocation;
  final int value;

  @override
  Widget build(BuildContext context) {
    return InitScale(
      child: TouchableOpacity(
        tooltip: tooltip,
        tooltipLocation: tooltipLocation,
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isActive ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  largeNumberFormatter(value),
                  overflow: TextOverflow.ellipsis,
                  style: kDetail.copyWith(
                    color: isActive ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.primary,
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
