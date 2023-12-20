import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/behaviours/off.dart';
import 'package:confesi/presentation/shared/layout/swipebar.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAwardSheet(BuildContext context, String title, String desc, String emoji, int n,
    {VoidCallback? onComplete}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) => ClipRRect(
      // borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        constraints: BoxConstraints(maxHeight: heightFraction(context, 2 / 3)),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Transform.scale(
                        scale: 0.75,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.tertiary,
                                blurRadius: 30,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Off(
                            child: Text(
                              emoji,
                              style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 60),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      InitScale(
                        durationOfScaleInMilliseconds: 250,
                        child: Text(
                          emoji,
                          style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 60),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        title,
                        style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                      WidgetOrNothing(
                        showWidget: n > 0,
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Theme.of(context).colorScheme.background, width: 2),
                              ),
                              child: Text(
                                "x$n",
                                style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    desc,
                    style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
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
