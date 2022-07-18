import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/typography.dart';
import '../buttons/touchable_opacity.dart';

class MinimalAppbarLayout extends StatelessWidget {
  const MinimalAppbarLayout(
      {this.iconTap,
      this.textTap,
      this.icon,
      this.bottomBorder = true,
      this.showIcon = true,
      this.text = "",
      Key? key})
      : super(key: key);

  final String text;
  final bool showIcon;
  final bool bottomBorder;
  final IconData? icon;
  final Function? iconTap;
  final Function? textTap;

  Widget children(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.background,
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
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Icon(icon ?? CupertinoIcons.arrow_turn_up_left),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Icon(icon ?? CupertinoIcons.chevron_back, color: Colors.transparent),
                  ),
            Expanded(
              child: textTap != null
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TouchableOpacity(
                        onTap: () => textTap!(),
                        child: Text(
                          text,
                          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Text(
                      text,
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Icon(CupertinoIcons.chevron_back, color: Colors.transparent),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? Hero(tag: "appbar", child: children(context))
        : children(context);
  }
}
