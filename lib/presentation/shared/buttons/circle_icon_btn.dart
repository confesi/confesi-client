import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../button_touch_effects/touchable_scale.dart';

class CircleIconBtn extends StatelessWidget {
  CircleIconBtn({super.key, required this.onTap});

  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(8),
        // Transparent hitbox trick
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.8,
          ),
        ),
        child: Icon(
          CupertinoIcons.xmark,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
