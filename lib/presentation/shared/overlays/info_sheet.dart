import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../layout/swipebar.dart';

Future<dynamic> showInfoSheet(BuildContext context, String header, String body) {
  HapticFeedback.lightImpact();
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SwipebarLayout(),
          const SizedBox(height: 15),
          Text(
            header,
            style: kTitle.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Flexible(
            child: ScrollableView(
              horizontalPadding: 30,
              child: InitOpacity(
                child: InitTransform(
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
                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
