import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubit/scaffold_shrinker_cubit.dart';
import '../../../core/styles/typography.dart';
import '../layout/swipebar.dart';

Future<dynamic> showDatePickerSheet(BuildContext context) async {
  context.read<ScaffoldShrinkerCubit>().setShrunk();
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 15),
          color: Theme.of(context).colorScheme.background,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Text(
                      "View the top confessions from any day.",
                      style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleTextButton(
                      onTap: () => Navigator.pop(context),
                      text: "Load today",
                    ),
                    const SizedBox(width: 15),
                    SimpleTextButton(
                      onTap: () => Navigator.pop(context),
                      text: "Load selected day",
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: kBody,
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
              ],
            ),
          ),
        ),
      ),
    ),
  ).whenComplete(
    () => context.read<ScaffoldShrinkerCubit>().setExpanded(),
  );
}
