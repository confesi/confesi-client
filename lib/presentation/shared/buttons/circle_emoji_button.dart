import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

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
    return TouchableOpacity(
      onTap: () => onTap(),
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
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
