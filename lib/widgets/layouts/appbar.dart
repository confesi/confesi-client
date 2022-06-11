import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/profile/profile_home.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class AppbarLayout extends StatelessWidget {
  const AppbarLayout({this.bottomBorder = true, this.backNav = true, required this.text, Key? key})
      : super(key: key);

  final String text;
  final bool backNav;
  final bool bottomBorder;

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
              backNav
                  ? TouchableOpacity(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        color: Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(CupertinoIcons.chevron_back),
                        ),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(CupertinoIcons.chevron_back, color: Colors.transparent),
                    ),
              Text(
                text,
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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
