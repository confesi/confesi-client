import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class SpreadRowText extends StatelessWidget {
  const SpreadRowText({
    required this.leftText,
    required this.rightText,
    this.onPress,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPress;
  final String leftText;
  final String rightText;

  Widget buildContent(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              leftText,
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
            onPress != null
                ? Row(
                    children: [
                      const SizedBox(width: 5),
                      Icon(
                        CupertinoIcons.pen,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 16,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                rightText,
                maxLines: 5,
                style: kBody.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return onPress != null
        ? TouchableOpacity(
            child: Container(
              // Transparent hitbox trick.
              color: Colors.transparent,
              child: buildContent(context),
            ),
            onTap: () => onPress!(),
          )
        : buildContent(context);
  }
}
