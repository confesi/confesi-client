import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../../dependency_injection.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/behaviours/init_transform.dart';
import '../../shared/buttons/animated_simple_text.dart';
import '../../shared/layout/swipebar.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SwipebarLayout(),
        SizedBox(
          // This infinite width ensure it is presented on its own row inside the Wrap widget.
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              "View top confessions from the past.",
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
                      onTap: () {
                        context.read<HottestCubit>().loadPosts(DateTime.now());
                        Navigator.pop(context);
                      },
                      text: "Load today",
                    ),
                  ),
                  const SizedBox(width: 15),
                  InitTransform(
                    transformDirection: TransformDirection.horizontal,
                    magnitudeOfTransform: -100,
                    child: AnimatedSimpleTextButton(
                      onTap: () {
                        context.read<HottestCubit>().loadPosts(selectedDate);
                        Navigator.pop(context);
                      },
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
                        maximumDate: DateTime.now(),
                        initialDateTime: selectedDate,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime date) => selectedDate = date,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
