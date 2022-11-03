import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    required this.onPress,
    this.bottomPadding = 15,
    required this.bottomText,
    required this.topText,
    this.leftIcon = CupertinoIcons.info,
    this.rightIcon = CupertinoIcons.chevron_right,
    Key? key,
  }) : super(key: key);

  final IconData rightIcon;
  final String bottomText;
  final String topText;
  final IconData leftIcon;
  final double bottomPadding;
  final VoidCallback onPress;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topText,
                      style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
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
                  ],
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
