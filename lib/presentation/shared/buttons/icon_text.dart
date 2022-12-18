import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    required this.onPress,
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
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => onPress(),
      child: Container(
        // transparent color trick to increase hitbox size
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
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
