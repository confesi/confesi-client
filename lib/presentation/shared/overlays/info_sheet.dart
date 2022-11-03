import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';

import '../layout/swipebar.dart';

Future<dynamic> showInfoSheet(BuildContext context, String header, String body) {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SwipebarLayout(),
        Container(
          padding: EdgeInsets.only(bottom: bottomSafeArea(context) + 15, top: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                header,
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Flexible(
                child: ScrollableView(
                  horizontalPadding: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        body,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
