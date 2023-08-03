import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class SearchedUniversityTile extends StatelessWidget {
  const SearchedUniversityTile({
    required this.onPress,
    required this.topText,
    required this.middleText,
    required this.bottomText,
    required this.watched,
    required this.home,
    this.leftIcon = CupertinoIcons.info,
    required this.onWatchChange,
    required this.onHomeChange,
    Key? key,
  }) : super(key: key);

  final bool watched;
  final bool home;
  final String topText;
  final String middleText;
  final String bottomText;
  final IconData leftIcon;
  final VoidCallback onPress;
  final Function(bool newValue) onWatchChange;
  final Function(bool newValue) onHomeChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      // transparent color trick to increase hitbox size
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topText,
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              middleText,
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              bottomText,
              style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
            SimpleTextButton(
                onTap: () => onWatchChange(!watched), text: watched ? "Unwatch" : "Watch", infiniteWidth: true),
            const SizedBox(height: 5),
            home
                ? Center(
                    child: Text(
                      "Current home school",
                      style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SimpleTextButton(onTap: () => onWatchChange(!home), text: "Set as home", infiniteWidth: true),
          ],
        ),
      ),
    );
  }
}
