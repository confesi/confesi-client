import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:Confessi/core/widgets/sheets/button_options_sheet.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/large_number_formatter.dart';

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
    return TouchableOpacity(
      tooltip: tooltip,
      tooltipLocation: tooltipLocation,
      onTap: () => onTap(),
      child: Container(
        // Transparent hitbox trick.
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(width: 5),
            Text(
              largeNumberFormatter(value),
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
