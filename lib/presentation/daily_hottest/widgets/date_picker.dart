import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/behaviours/init_transform.dart';
import '../../shared/buttons/pop.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PopButton(
                bottomPadding: 15,
                justText: true,
                onPress: () {
                  context.read<HottestCubit>().loadPosts(DateTime.now());
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.chevron_right,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.primary,
                text: "Load today",
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: PopButton(
                bottomPadding: 15,
                justText: true,
                onPress: () {
                  context.read<HottestCubit>().loadPosts(selectedDate);
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.chevron_right,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                text: "Load selected",
              ),
            ),
          ],
        ),
        Expanded(
          child: InitScale(
            delayDurationInMilliseconds: 150,
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
    );
  }
}
