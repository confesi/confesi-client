import 'package:Confessi/presentation/shared/buttons/option.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/layout/swipebar.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';

Future<dynamic> showButtonOptionsSheet(BuildContext context, List<OptionButton> buttons,
    {String? text, VoidCallback? onComplete}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SwipebarLayout(),
        Container(
          padding: EdgeInsets.only(bottom: bottomSafeArea(context) + 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScrollableView(
                  thumbVisible: false,
                  child: Column(
                    children: [
                      ...buttons,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
