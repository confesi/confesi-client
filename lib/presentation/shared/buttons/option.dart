import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';

import '../behaviours/init_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    this.popContext = true,
    required this.onTap,
    required this.text,
    required this.icon,
    this.isRed = false,
    Key? key,
  }) : super(key: key);

  final bool popContext;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: TouchableOpacity(
        onTap: () {
          popContext ? Navigator.pop(context) : null;
          onTap();
        },
        child: Container(
          // Transparent hitbox trick.
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text,
                    style: kTitle.copyWith(
                      color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
