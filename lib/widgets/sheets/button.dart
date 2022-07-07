import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../buttons/option.dart';
import '../layouts/scrollbar.dart';

Future<dynamic> showButtonSheet(BuildContext context) {
  return showMaterialModalBottomSheet(
    expand: false,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius:
          const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ScrollbarLayout(),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: const [
                  OptionButton(
                    text: "Report",
                    icon: CupertinoIcons.nosign,
                  ),
                  OptionButton(
                    text: "Share",
                    icon: CupertinoIcons.share,
                  ),
                  OptionButton(
                    text: "Repost",
                    icon: CupertinoIcons.paperplane,
                  ),
                  OptionButton(
                    text: "Save",
                    icon: CupertinoIcons.bookmark,
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
