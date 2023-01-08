import '../behaviours/init_opacity.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class StatTileItem extends StatelessWidget {
  const StatTileItem({super.key, required this.text, required this.icon, required this.onTap, this.color});

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TouchableOpacity(
        onTap: () => onTap(),
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color ?? Theme.of(context).colorScheme.onSecondary,
                  // color: Colors.white,
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: kDetail.copyWith(
                    color: color ?? Theme.of(context).colorScheme.onSecondary,
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
