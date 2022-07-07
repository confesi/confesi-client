import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/touchable_opacity.dart';

class AppbarLayout extends StatelessWidget {
  const AppbarLayout(
      {this.iconTap,
      this.icon,
      this.iconRight,
      this.iconRightTap,
      this.bottomBorder = true,
      this.showIcon = true,
      this.showRightIcon = false,
      required this.centerWidget,
      this.centerWidgetFullWidth = false,
      Key? key})
      : super(key: key);

  final bool centerWidgetFullWidth;
  final Widget centerWidget;
  final bool showIcon;
  final bool showRightIcon;
  final bool bottomBorder;
  final IconData? icon;
  final Function? iconTap;
  final IconData? iconRight;
  final Function? iconRightTap;

  Widget children(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.background,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color:
                      bottomBorder ? Theme.of(context).colorScheme.background : Colors.transparent,
                  width: .35),
            ),
          ),
          child: centerWidgetFullWidth
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: centerWidget,
                  ),
                )
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showIcon
                          ? TouchableOpacity(
                              onTap: () {
                                if (iconTap != null) {
                                  iconTap!();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(icon ?? CupertinoIcons.chevron_back),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(icon ?? CupertinoIcons.chevron_back,
                                  color: Colors.transparent),
                            ),
                      Expanded(
                        child: centerWidget,
                      ),
                      showRightIcon
                          ? TouchableOpacity(
                              onTap: () {
                                if (iconRightTap != null) {
                                  iconRightTap!();
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(iconRight ?? CupertinoIcons.arrow_clockwise),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(iconRight ?? CupertinoIcons.arrow_clockwise,
                                  color: Colors.transparent),
                            ),
                    ],
                  ),
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? Hero(tag: "appbar", child: children(context))
        : children(context);
  }
}
