import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../buttons/pop.dart';
import '../layout/swipebar.dart';

Future<dynamic> showInfoSheetWithAction(
  BuildContext context,
  String header,
  String body,
  VoidCallback onTap,
  String buttonText,
) {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(maxHeight: heightFraction(context, .75)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SwipebarLayout(),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: bottomSafeArea(context), top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  header,
                  style: kDisplay1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  body,
                  style: kBody.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                PopButton(
                  bottomPadding: bottomSafeArea(context),
                  justText: true,
                  onPress: () {
                    Navigator.pop(context);
                    onTap();
                  },
                  icon: CupertinoIcons.chevron_right,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  text: buttonText,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
