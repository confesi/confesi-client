import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/touchable_opacity.dart';

/// If [leftIconOnPress] is null, defaults to popping current context.
class AppbarLayout extends StatelessWidget {
  const AppbarLayout({
    this.leftIcon,
    this.rightIcon,
    this.leftIconOnPress,
    this.rightIconOnPress,
    this.bottomBorder = true,
    this.leftIconVisible = true,
    this.rightIconVisible = false,
    required this.centerWidget,
    this.centerWidgetFullWidth = false,
    this.heroAnimEnabled = true,
    Key? key,
  }) : super(key: key);

  final bool centerWidgetFullWidth;
  final Widget centerWidget;
  final bool leftIconVisible;
  final bool rightIconVisible;
  final bool bottomBorder;
  final IconData? leftIcon;
  final Function? leftIconOnPress;
  final IconData? rightIcon;
  final Function? rightIconOnPress;
  final bool heroAnimEnabled;

  Widget children(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.background,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: bottomBorder
                    ? Theme.of(context).colorScheme.background
                    : Colors.transparent,
                width: .35,
              ),
            ),
          ),
          child: Center(
            child: centerWidgetFullWidth
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: centerWidget,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      leftIconVisible
                          ? TouchableOpacity(
                              onTap: () {
                                if (leftIconOnPress != null) {
                                  leftIconOnPress!();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                      leftIcon ?? CupertinoIcons.chevron_back),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                key: const Key('appbar-icon'),
                                leftIcon ?? CupertinoIcons.chevron_back,
                                color: Colors.transparent,
                              ),
                            ),
                      Expanded(
                        child: centerWidget,
                      ),
                      rightIconVisible
                          ? TouchableOpacity(
                              tooltipLocation: TooltipLocation.below,
                              onTap: () {
                                if (rightIconOnPress != null) {
                                  rightIconOnPress!();
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    rightIcon ?? CupertinoIcons.arrow_clockwise,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                  rightIcon ?? CupertinoIcons.arrow_clockwise,
                                  color: Colors.transparent),
                            ),
                    ],
                  ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS && heroAnimEnabled
        ? Hero(
            tag: 'appbar',
            child: children(context),
          )
        : children(context);
  }
}
