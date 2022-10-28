import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:flutter/material.dart';

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
    return TouchableOpacity(
      onTap: () {
        popContext ? Navigator.pop(context) : null;
        onTap();
      },
      child: Container(
        width: double.infinity,
        // Transparent hitbox trick.
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: kBody.copyWith(
                    color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
