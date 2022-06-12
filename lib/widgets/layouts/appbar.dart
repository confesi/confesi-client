import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/profile/profile_home.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class AppbarLayout extends StatelessWidget {
  const AppbarLayout(
      {this.iconTap,
      this.textTap,
      this.icon,
      this.bottomBorder = true,
      this.showIcon = true,
      required this.text,
      Key? key})
      : super(key: key);

  final String text;
  final bool showIcon;
  final bool bottomBorder;
  final IconData? icon;
  final Function? iconTap;
  final Function? textTap;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "appbar",
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: bottomBorder
                      ? Theme.of(context).colorScheme.onBackground
                      : Colors.transparent,
                  width: 1),
            ),
          ),
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
                padding: EdgeInsets.all(10),
                child: Icon(CupertinoIcons.chevron_back, color: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
