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
    this.centered = false,
    Key? key,
  }) : super(key: key);

  final bool centered;
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
        color: Theme.of(context).colorScheme.background,
        border: centered
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.25,
                ),
              ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                centered
                    ? Container()
                    : Icon(
                        icon,
                        color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                      ),
                centered ? Container() : const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text,
                    style: kBody.copyWith(
                      color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: centered ? TextAlign.center : TextAlign.left,
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
