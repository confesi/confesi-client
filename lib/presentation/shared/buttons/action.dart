import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    this.backgroundColor,
    required this.icon,
    required this.onPress,
    required this.text,
    this.iconColor,
    this.textColor,
    this.loading = false,
    Key? key,
  }) : super(key: key);

  final bool loading;
  final String text;
  final VoidCallback onPress;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: SizedBox(
                  key: UniqueKey(),
                  width: 20,
                  child: loading
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Icon(
                          icon,
                          color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
                          size: 20,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 3, top: 4),
                child: Text(
                  text,
                  style: kBody.copyWith(color: textColor ?? Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
