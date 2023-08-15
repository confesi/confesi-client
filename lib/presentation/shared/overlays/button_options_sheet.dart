import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/option.dart';
import '../layout/swipebar.dart';

Future<dynamic> showButtonOptionsSheet(BuildContext context, List<OptionButton> buttons,
    {String? text, VoidCallback? onComplete}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) => ClipRRect(
      // borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: bottomSafeArea(context)),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SwipebarLayout(),
            SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      ...buttons,
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
