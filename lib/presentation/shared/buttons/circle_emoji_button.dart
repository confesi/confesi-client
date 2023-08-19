import 'package:confesi/presentation/shared/button_touch_effects/touchable_burst.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';

class CircleEmojiButton extends StatelessWidget {
  const CircleEmojiButton({
    required this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 75),
        child: Container(
          // transparent hitbox trick
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
      ),
    );
  }
}
