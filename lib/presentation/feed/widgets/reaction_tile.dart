import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ReactionTile extends StatelessWidget {
  const ReactionTile({
    super.key,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final int amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => print("tap"),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 10),
            Text(
              largeNumberFormatter(amount),
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
