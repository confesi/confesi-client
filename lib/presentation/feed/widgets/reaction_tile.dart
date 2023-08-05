import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../../core/styles/typography.dart';

class ReactionTile extends StatelessWidget {
  const ReactionTile({
    super.key,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.simpleView = false,
    this.isSelected = false,
    this.onTap,
  });

  final bool simpleView;
  final int amount;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
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
    );

    if (onTap != null) {
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap!,
        child: content,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(top: 11, bottom: 10, left: simpleView ? 0 : 15, right: simpleView ? 0 : 15),
      decoration: BoxDecoration(
        border: simpleView
            ? null
            : Border.all(
                color: Theme.of(context).colorScheme.onBackground,
                width: 0.8,
                strokeAlign: BorderSide.strokeAlignInside),
        color: simpleView ? Colors.transparent : Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: content,
    );
  }
}
