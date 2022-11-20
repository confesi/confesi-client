import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../layout/swipebar.dart';

Future<dynamic> showInfoSheet(BuildContext context, String header, String body) {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(maxHeight: heightFraction(context, .75)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SwipebarLayout(),
          Flexible(
            child: ScrollableView(
              distancebetweenHapticEffectsDuringScroll: 50,
              hapticEffectAtEdge: HapticType.medium,
              scrollBarVisible: false,
              inlineTopOrLeftPadding: 15,
              inlineBottomOrRightPadding: bottomSafeArea(context),
              controller: ScrollController(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    header,
                    style: kSansSerifDisplay.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    body,
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: bottomSafeArea(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
