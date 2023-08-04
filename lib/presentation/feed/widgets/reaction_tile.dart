import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ReactionTile extends StatelessWidget {
  const ReactionTile({
    super.key,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.isSelected = false,
  });

  final int amount;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("tap"),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? iconColor : Theme.of(context).colorScheme.onSurface,
              size: 17,
            ),
            const SizedBox(width: 5),
            Text(
              largeNumberFormatter(amount),
              style: kTitle.copyWith(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
