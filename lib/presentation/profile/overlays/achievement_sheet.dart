import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/pop.dart';
import '../../shared/layout/swipebar.dart';

Future<dynamic> showAchievementSheet(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SwipebarLayout(),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: bottomSafeArea(context) + 15, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Celebrity x4",
                  style: kDisplay1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(
                      color: Colors.blue,
                      // width: 2,
                    ),
                  ),
                  child: Text(
                    "Rare",
                    style: kDetail.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Reach the daily hottest page on 4 separate occasions.",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.left,
                ),
                // const SizedBox(height: 30),
                // PopButton(
                //   bottomPadding: bottomSafeArea(context),
                //   justText: true,
                //   onPress: () {
                //     Navigator.pop(context);
                //     onTap();
                //   },
                //   icon: CupertinoIcons.chevron_right,
                //   backgroundColor: Theme.of(context).colorScheme.secondary,
                //   textColor: Theme.of(context).colorScheme.onSecondary,
                //   text: buttonText,
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
