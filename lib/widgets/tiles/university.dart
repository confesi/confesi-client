import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/icon_text.dart';
import '../symbols/circle.dart';

class UniversityTile extends StatelessWidget {
  const UniversityTile({required this.universityCode, required this.universityName, Key? key})
      : super(key: key);

  final String universityCode;
  final String universityName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () => print("university tile tapped"),
        child: Container(
          // Container hitbox transparency trick
          color: Colors.transparent,
          child: Row(
            children: [
              const CircleSymbol(
                icon: CupertinoIcons.flame,
                radius: 26,
              ),
              SizedBox(
                width: 200,
                child: IconTextButton(
                  onPress: () => print("TAP"),
                  text: "$universityName • $universityCode",
                  leftIcon: CupertinoIcons.bell,
                  bottomPadding: 30,
                ),
              ),
              const Spacer(),
              Icon(
                CupertinoIcons.chevron_right,
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
