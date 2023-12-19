import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class AwardTile extends StatelessWidget {
  const AwardTile(
      {super.key, required this.title, required this.desc, required this.emoji, required this.count, this.fontSize});

  final String title;
  final String desc;
  final String emoji;
  final int count;
  final double? fontSize; // Optional fontSize parameter

  @override
  Widget build(BuildContext context) {
    TextStyle emojiStyle = kTitle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontSize: fontSize ?? 24, // Use provided fontSize or default to 24
    );

    return TouchableOpacity(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 1.5, top: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                emoji,
                style: emojiStyle,
              ),
            ),
          ),
          if (count > 0)
            Positioned(
              bottom: 3,
              right: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).colorScheme.background, width: 2),
                ),
                child: Text(
                  '$count',
                  style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (count == 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
