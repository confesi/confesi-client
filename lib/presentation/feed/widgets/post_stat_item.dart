import '../../shared/behaviours/init_opacity.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';

class PostStatItem extends StatelessWidget {
  const PostStatItem({super.key, required this.text, required this.icon, required this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback onTap;

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
                  color: Theme.of(context).colorScheme.onSecondary,
                  // color: Colors.white,
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
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
