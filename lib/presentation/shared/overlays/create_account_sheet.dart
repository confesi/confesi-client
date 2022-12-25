import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile_group.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../button_touch_effects/touchable_opacity.dart';
import '../buttons/pop.dart';
import '../layout/swipebar.dart';

Future<dynamic> showCreateAccountSheet(
  BuildContext context,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create an account to do this & more.",
                  style: kDisplay1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                PopButton(
                  bottomPadding: 15,
                  justText: true,
                  onPress: () {
                    Navigator.pop(context);
                  },
                  icon: CupertinoIcons.chevron_right,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  text: "Create account",
                ),
                TouchableOpacity(
                  onTap: () => {}, // TODO: Implement
                  child: Container(
                    // Transparent hitbox trick.
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Login instead",
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: bottomSafeArea(context)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
