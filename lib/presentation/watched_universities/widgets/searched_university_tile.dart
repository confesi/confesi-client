import 'watched_university_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class SearchedUniversityTile extends StatelessWidget {
  const SearchedUniversityTile({
    required this.onPress,
    required this.topText,
    required this.bottomText,
    this.leftIcon = CupertinoIcons.info,
    Key? key,
  }) : super(key: key);

  final String bottomText;
  final String topText;
  final IconData leftIcon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      // transparent color trick to increase hitbox size
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topText,
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bottomText,
                    style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "uvic",
                    style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const WatchedUniversityIndicator(),
          ],
        ),
      ),
    );
  }
}
