import 'package:Confessi/presentation/create_post/widgets/draft_tile.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/slideables/slidable_section.dart';
import '../../shared/buttons/emblem.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/swipebar.dart';
import '../../shared/overlays/info_sheet_with_action.dart';

Future<dynamic> showDraftsSheet(BuildContext context) {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(maxHeight: heightFraction(context, .9)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // EmblemButton(
          //   backgroundColor: Theme.of(context).colorScheme.surface,
          //   icon: CupertinoIcons.xmark,
          //   onPress: () => Navigator.pop(context),
          //   iconColor: Theme.of(context).colorScheme.onSurface,
          // ),
          const SwipebarLayout(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                Text(
                  "Load a draft confession",
                  style: kDisplay1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  "These are saved locally to your device, and lost upon sign out.",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                SimpleTextButton(
                  onTap: () => Navigator.pop(context),
                  text: "Go back to writing",
                  infiniteWidth: true,
                ),
              ],
            ),
          ),
          LineLayout(color: Theme.of(context).colorScheme.surface),
          Expanded(
            child: ScrollableView(
              inlineBottomOrRightPadding: bottomSafeArea(context),
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              hapticsEnabled: false,
              scrollBarVisible: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DraftTile(
                      text:
                          "text that is really long I guess that is crazy ahhh lets hope this reaches the line limit and showswhat over",
                      onDelete: () => print("tap")),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
