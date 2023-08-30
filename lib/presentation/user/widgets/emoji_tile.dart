import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

class EmojiTile extends StatelessWidget {
  const EmojiTile({Key? key, required this.emoji, required this.desc}) : super(key: key);

  final String emoji;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onBackground,
            width: borderSize,
          ),
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              emoji,
              style: kDisplay2.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 50),
            ),
            Expanded(
              child: Text(
                desc,
                style: kBody.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
