import 'package:Confessi/core/widgets/layout/swipebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/option.dart';

Future<dynamic> showButtonOptionsSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SwipebarLayout(),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  OptionButton(
                    text: "Report",
                    icon: CupertinoIcons.nosign,
                    onTap: () => print("tap"),
                  ),
                  OptionButton(
                    text: "Share",
                    icon: CupertinoIcons.share,
                    onTap: () => print("tap"),
                  ),
                  OptionButton(
                    text: "Reply",
                    icon: CupertinoIcons.paperplane,
                    onTap: () => print("tap"),
                  ),
                  OptionButton(
                    text: "Save",
                    icon: CupertinoIcons.bookmark,
                    onTap: () => print("tap"),
                  ),
                  OptionButton(
                    text: "Details",
                    icon: CupertinoIcons.info,
                    onTap: () => print("tap"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
