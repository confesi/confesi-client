import 'dart:math';

import 'package:confesi/presentation/shared/overlays/info_sheet.dart';
import 'package:confesi/presentation/user/widgets/emoji_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';

class EmojisScreen extends StatefulWidget {
  const EmojisScreen({Key? key}) : super(key: key);

  @override
  State<EmojisScreen> createState() => _EmojisScreenState();
}

class _EmojisScreenState extends State<EmojisScreen> {
  late ScrollController controller;

  @override
  void initState() {
    controller = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppbarLayout(
              rightIconVisible: true,
              rightIcon: CupertinoIcons.info,
              rightIconOnPress: () => showInfoSheet(context, "Emoji legend",
                  "Each confession gets tagged with emojis. They mean different things. Some are easy to get... while others are more difficult."),
              bottomBorder: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerWidget: Text(
                "Emoji Legend",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.shadow,
                child: ListWheelScrollView.useDelegate(
                  physics: const FixedExtentScrollPhysics(),
                  controller: controller,
                  perspective: 0.006,
                  itemExtent: 170,
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: [
                      const EmojiTile(
                        emoji: "💀",
                        desc: "Earned when a confession is shockingly revealing or controversial.",
                      ),
                      const EmojiTile(
                        emoji: "😆",
                        desc: "Earned when a confession brings a smile to many faces.",
                      ),
                      const EmojiTile(
                        emoji: "😎",
                        desc: "Earned when a confession is undeniably cool or has a swagger.",
                      ),
                      const EmojiTile(
                        emoji: "🦭",
                        desc: "Awarded for a confession that's uniquely playful or stands out.",
                      ),
                      const EmojiTile(
                        emoji: "✅",
                        desc: "Earned when a confession has more likes than dislikes.",
                      ),
                      const EmojiTile(
                        emoji: "🎲",
                        desc: "Received for a confession that took a risk or was a gamble.",
                      ),
                      const EmojiTile(
                        emoji: "🙅‍♂️",
                        desc: "Given to a confession that defies conventions or breaks the mold.",
                      ),
                      const EmojiTile(
                        emoji: "🫥",
                        desc: "Earned when a confession has lots of comments and engagement.",
                      ),
                      const EmojiTile(
                        emoji: "🤍",
                        desc:
                            "Received under a mysterious circumstance. Only the chosen few understand its significance.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
