import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class StatTileItem extends StatelessWidget {
  const StatTileItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TouchableScale(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).colorScheme.onSecondary,
                  // color: Colors.white,
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: kDetail.copyWith(
                    color: textColor ?? Theme.of(context).colorScheme.onSecondary,
                    // color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
