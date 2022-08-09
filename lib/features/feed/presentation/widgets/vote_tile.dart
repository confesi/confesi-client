import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:Confessi/core/widgets/sheets/button_options.dart';
import 'package:flutter/material.dart';

class VoteTile extends StatelessWidget {
  const VoteTile({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.tooltip,
    this.tooltipLocation,
    this.showOutline = true,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String? tooltip;
  final TooltipLocation? tooltipLocation;
  final bool showOutline;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tooltip: tooltip,
      tooltipLocation: tooltipLocation,
      onTap: () => onTap(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showOutline
              ? Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground,
                  width: 0.7,
                )
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 15,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
