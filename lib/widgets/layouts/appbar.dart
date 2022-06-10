import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';

class AppbarLayout extends StatelessWidget {
  const AppbarLayout({required this.text, Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "appbar",
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TouchableOpacity(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.transparent,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CupertinoIcons.chevron_back),
                  ),
                ),
              ),
              Text(
                text,
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
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
