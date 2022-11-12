import '../buttons/option.dart';
import '../layout/line.dart';
import '../layout/scrollable_area.dart';
import '../layout/swipebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';

Future<dynamic> showButtonOptionsSheet(BuildContext context, List<OptionButton> buttons,
    {String? text, VoidCallback? onComplete}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScrollableArea(
                    thumbVisible: false,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          LineLayout(color: Theme.of(context).colorScheme.onBackground),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            child: Column(
                              children: [
                                ...buttons,
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            child: OptionButton(
                                onTap: () => print("tap"), text: "Done", icon: CupertinoIcons.xmark, isRed: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
