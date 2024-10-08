import 'package:confesi/core/services/haptics/haptics.dart';

import '../button_touch_effects/touchable_scale.dart';

import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../indicators/loading_cupertino.dart';

class PopButton extends StatelessWidget {
  const PopButton({
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.horizontalPadding = 0.0,
    required this.onPress,
    required this.icon,
    this.justText = false,
    this.loading = false,
    Key? key,
  }) : super(key: key);

  final bool loading;
  final bool justText;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final String text;
  final double topPadding;
  final double bottomPadding;
  final double horizontalPadding;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: topPadding, bottom: bottomPadding),
      child: IgnorePointer(
        ignoring: loading,
        child: TouchableScale(
          onTap: () {
            Haptics.f(H.regular);
            onPress();
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.3), blurRadius: 30),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: justText ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 24,
                      child: Align(
                        alignment: justText ? Alignment.center : Alignment.centerLeft,
                        child: loading
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: LoadingCupertinoIndicator(color: textColor),
                              )
                            : Text(
                                text,
                                textScaleFactor: 1,
                                style: kTitle.copyWith(color: textColor),
                                textAlign: justText ? TextAlign.center : TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  ),
                  if (!justText) const SizedBox(width: 5), // Use if condition for conditional widget rendering
                  if (!justText) Icon(icon, color: textColor), // Use if condition for conditional widget rendering
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
