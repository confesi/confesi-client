import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton(
      {required this.onPress,
      this.bottomPadding = 15,
      required this.text,
      this.leftIcon = CupertinoIcons.info,
      this.leftIconVisible = true,
      this.rightIcon = CupertinoIcons.chevron_right,
      Key? key})
      : super(key: key);

  final IconData rightIcon;
  final String text;
  final IconData leftIcon;
  final double bottomPadding;
  final VoidCallback onPress;
  final bool leftIconVisible;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onPress(),
      child: Container(
        // transparent color trick to increase hitbox size
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: [
              leftIconVisible
                  ? Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Icon(
                        leftIcon,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Container(),
              Expanded(
                child: Text(
                  text,
                  style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                rightIcon,
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
