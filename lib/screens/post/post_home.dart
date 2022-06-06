import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/buttons/action.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';

class PostHome extends StatelessWidget {
  const PostHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const GroupText(
                  widthMultiplier: 80,
                  body: "Please be civil, but have fun. Posts are never linked to your account.",
                  header: "Create Confession",
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(
                      onPress: () {},
                      text: "add details",
                      icon: CupertinoIcons.pen,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 15),
                    ActionButton(
                      onPress: () => {print("tap")},
                      text: "publish post",
                      icon: CupertinoIcons.up_arrow,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      iconColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                LineLayout(color: Theme.of(context).colorScheme.surface),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
