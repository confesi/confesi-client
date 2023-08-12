
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';
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
    this.noRightIcon = false,
    this.bgColor,
    this.iconColor,
  });

  final Color? iconColor;
  final bool noRightIcon;
  final bool isRedText;
  final IconData leftIcon;
  final String text;
  final String? secondaryText;
  final VoidCallback onTap;
  final IconData? rightIcon;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
          color: bgColor ?? Theme.of(context).colorScheme.background,
          borderRadius:  BorderRadius.all(Radius.circular(Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              leftIcon,
              color:
                  isRedText ? Theme.of(context).colorScheme.error : iconColor ?? Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        secondaryText != null
                            ? Text(
                                secondaryText!,
                                textAlign: TextAlign.right,
                                style: kBody.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  secondaryText != null ? const SizedBox(width: 10) : Container(),
                ],
              ),
            ),
            noRightIcon
                ? Container()
                : Icon(
                    rightIcon ?? CupertinoIcons.arrow_right,
                    color: isRedText
                        ? Theme.of(context).colorScheme.error
                        : iconColor ?? Theme.of(context).colorScheme.primary,
                  ),
          ],
        ),
      ),
    );
  }
}
