import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/symbols/circle.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.displayName, required this.username, Key? key}) : super(key: key);

  final String displayName;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: GestureDetector(
        onTap: () => print("user tile tapped"),
        child: Container(
          // Container hitbox transparency trick
          color: Colors.transparent,
          child: Row(
            children: [
              const CircleSymbol(
                icon: CupertinoIcons.flame,
                radius: 26,
              ),
              GroupText(
                leftAlign: true,
                body: username,
                header: displayName,
                small: true,
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
