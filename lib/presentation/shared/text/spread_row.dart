import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

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

  Widget buildRightText(BuildContext context) => Text(
        rightText,
        maxLines: 5,
        style: kBody.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
      );

  Widget buildLeftText(BuildContext context) => Expanded(
        flex: 2,
        child: Text(
          leftText,
          style: kBody.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
      );

  Widget buildContent(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildLeftText(context),
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
            Flexible(
              child: buildRightText(context),
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
