import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/option.dart';
import '../layout/swipebar.dart';

Future<dynamic> showConfirmationSheet(BuildContext context, VoidCallback action, String text) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) => ClipRRect(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: bottomSafeArea(context) + 30),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SwipebarLayout(),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
                    child: Text(
                      text,
                      style: kDisplay1.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      OptionButton(
                        onTap: () async => action(),
                        text: "Yes",
                        icon: CupertinoIcons.check_mark,
                        isRed: true,
                      ),
                      OptionButton(
                        onTap:
                            () async {}, // does nothing, because by default it pops the go router context (putting sheet down)
                        text: "Nope 😬",
                        icon: CupertinoIcons.xmark,
                      ),
                    ],
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
