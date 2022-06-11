import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../behaviors/overscroll.dart';
import '../../constants/typography.dart';
import '../layouts/scrollbar.dart';

Future<dynamic> showPickerSheet(
    BuildContext context, List<String> items, int index, String header, Function(int) updateState) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius:
          const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          children: [
            const ScrollbarLayout(),
            const SizedBox(height: 15),
            Text(
              header,
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "Change your category",
              style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ScrollConfiguration(
                  behavior: NoOverScrollSplash(),
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: index),
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    looping: false,
                    itemExtent: 40,
                    onSelectedItemChanged: (newIndex) {
                      HapticFeedback.lightImpact();
                      updateState(newIndex);
                    },
                    children: items
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                child: Text(
                                  item,
                                  style: kBody.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 1,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
