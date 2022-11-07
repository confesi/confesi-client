import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/behaviours/init_transform.dart';
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InitTransform(
                      transformDirection: TransformDirection.horizontal,
                      child: SimpleTextButton(
                        onTap: () {
                          context.read<HottestCubit>().loadPosts(DateTime.now());
                          Navigator.pop(context);
                        },
                        text: "Load today",
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InitTransform(
                      transformDirection: TransformDirection.horizontal,
                      magnitudeOfTransform: -100,
                      child: SimpleTextButton(
                        onTap: () {
                          context.read<HottestCubit>().loadPosts(selectedDate);
                          Navigator.pop(context);
                        },
                        text: "Load selected",
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: InitScale(
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
            ],
          ),
        ),
      ],
    );
  }
}
