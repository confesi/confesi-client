import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../behaviours/touchable_opacity.dart';

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

  @override
  Widget build(BuildContext context) {
    return Material(
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
        child: Row(
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
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            leftIcon ?? CupertinoIcons.back,
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(rightIcon ?? CupertinoIcons.arrow_clockwise,
                        color: Colors.transparent),
                  ),
            Flexible(
              child: centerWidget,
            ),
            rightIconVisible
                ? TouchableOpacity(
                    onTap: () {
                      if (rightIconOnPress != null) {
                        rightIconOnPress!();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            rightIcon,
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(rightIcon ?? CupertinoIcons.arrow_clockwise,
                        color: Colors.transparent),
                  ),
          ],
        ),
      ),
    );
  }
}
