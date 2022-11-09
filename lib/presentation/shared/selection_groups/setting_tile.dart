import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.leftIcon,
    required this.text,
    required this.onTap,
    this.secondaryText,
    this.isRedText = false,
    this.rightIcon,
  });

  final bool isRedText;
  final IconData leftIcon;
  final String text;
  final String? secondaryText;
  final VoidCallback onTap;
  final IconData? rightIcon;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      // fadeSplashOut: false,
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              leftIcon,
              color: isRedText ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: kTitle.copyWith(
                        color: isRedText ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  secondaryText != null
                      ? Expanded(
                          child: Text(
                            secondaryText!,
                            textAlign: TextAlign.right,
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Container(),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Icon(
              rightIcon ?? CupertinoIcons.arrow_right,
              color: isRedText ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
