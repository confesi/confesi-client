import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    required this.leftNumber,
    required this.leftDescription,
    required this.centerNumber,
    required this.centerDescription,
    required this.rightNumber,
    required this.rightDescription,
    super.key,
  });

  final int leftNumber;
  final String leftDescription;
  final int centerNumber;
  final String centerDescription;
  final int rightNumber;
  final String rightDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // Transparent hitbox trick.
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Text(
                    largeNumberFormatter(leftNumber),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    leftDescription,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              // Transparent hitbox trick.
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Text(
                    largeNumberFormatter(centerNumber),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    centerDescription,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              // Transparent hitbox trick.
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Text(
                    largeNumberFormatter(rightNumber),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    rightDescription,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
