import 'package:Confessi/constants/shared/enums.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:Confessi/presentation/shared/indicators/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class PopButton extends StatelessWidget {
  const PopButton(
      {this.topPadding = 0.0,
      this.bottomPadding = 0.0,
      required this.backgroundColor,
      required this.textColor,
      required this.text,
      this.horizontalPadding = 0.0,
      required this.onPress,
      required this.icon,
      this.justText = false,
      this.loading = false,
      Key? key})
      : super(key: key);

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
        ignoring: loading ? true : false,
        child: TouchableOpacity(
          tapType: TapType.lightImpact,
          onTap: () => onPress(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: justText ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 24,
                      child: Align(
                        alignment: justText ? Alignment.center : Alignment.centerLeft,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (Widget child, Animation<double> animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: loading
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: LoadingIndicator(color: textColor),
                                )
                              : Text(
                                  text,
                                  textScaleFactor: 1,
                                  style: kTitle.copyWith(
                                    color: textColor,
                                  ),
                                  textAlign: justText ? TextAlign.center : TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ),
                    ),
                  ),
                  justText ? Container() : const SizedBox(width: 5),
                  justText
                      ? Container()
                      : Icon(
                          icon,
                          color: textColor,
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
