import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/buttons/animated_simple_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/layout/swipebar.dart';

Future<dynamic> showDatePickerSheet(BuildContext context) async {
  HapticFeedback.lightImpact();
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SwipebarLayout(),
              SizedBox(
                // This infinite width ensure it is presented on its own row inside the Wrap widget.
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text(
                    "View top confessions from any day.",
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InitTransform(
                          transformDirection: TransformDirection.horizontal,
                          child: AnimatedSimpleTextButton(
                            onTap: () => Navigator.pop(context),
                            text: "Load today",
                          ),
                        ),
                        const SizedBox(width: 15),
                        InitTransform(
                          transformDirection: TransformDirection.horizontal,
                          magnitudeOfTransform: -100,
                          child: AnimatedSimpleTextButton(
                            onTap: () => Navigator.pop(context),
                            text: "Load selected day",
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: InitScale(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (DateTime date) {
                                print(date);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
