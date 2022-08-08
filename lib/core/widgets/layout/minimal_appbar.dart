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
      this.pressable = true,
      this.farLeft = false,
      Key? key})
      : super(key: key);

  final String text;
  final bool pressable;
  final bool showIcon;
  final bool bottomBorder;
  final IconData? icon;
  final Function? iconTap;
  final Function? textTap;
  final bool farLeft;

  Widget children(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showIcon
                ? AbsorbPointer(
                    absorbing: !pressable,
                    child: TouchableOpacity(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: farLeft ? 10 : 30),
                          child: Icon(
                            key: const Key('minimal-appbar-icon'),
                            icon ?? CupertinoIcons.arrow_turn_up_left,
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: farLeft ? 10 : 30),
                    child: Icon(icon ?? CupertinoIcons.chevron_back,
                        color: Colors.transparent),
                  ),
            Expanded(
              child: textTap != null
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TouchableOpacity(
                        onTap: () => textTap!(),
                        child: Text(
                          text,
                          style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Text(
                      text,
                      style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: farLeft ? 10 : 30,
              ),
              child: const Icon(CupertinoIcons.chevron_back,
                  color: Colors.transparent),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? Hero(
            tag: 'minimal-appbar',
            child: children(context),
          )
        : children(context);
  }
}
