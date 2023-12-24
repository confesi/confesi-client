import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/haptics/haptics.dart';

import '../button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    this.popContext = true,
    required this.onTap,
    required this.text,
    required this.icon,
    this.isRed = false,
    this.noBottomPadding = false,
    this.primaryColor,
    this.borderColor,
    this.topPadding = false,
    this.bottomPadding = false,
    Key? key,
  }) : super(key: key);

  final bool topPadding;
  final bool bottomPadding;
  final bool popContext;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRed;
  final bool noBottomPadding;
  final Color? primaryColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ? 15 : 0, bottom: bottomPadding ? 15 : 0),
      child: TouchableScale(
        onTap: () {
          popContext ? Navigator.pop(context) : null;
          Haptics.f(H.regular);
          onTap();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: noBottomPadding ? 0 : 5),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? Theme.of(context).colorScheme.onBackground,
              width: borderSize + 0.4,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: primaryColor ??
                        (isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      text,
                      style: kTitle.copyWith(
                        color: primaryColor ??
                            (isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
