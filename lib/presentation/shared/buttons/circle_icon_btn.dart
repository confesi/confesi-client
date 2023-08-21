import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../button_touch_effects/touchable_scale.dart';

class CircleIconBtn extends StatelessWidget {
  CircleIconBtn({
    super.key,
    required this.onTap,
    required this.icon,
    this.color,
    this.disabled = false,
  });

  VoidCallback onTap;
  final IconData icon;
  final Color? color;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: TouchableScale(
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
              icon,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
