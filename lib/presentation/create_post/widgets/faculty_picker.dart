import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/behaviours/init_transform.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/swipebar.dart';

class FacultyPicker extends StatefulWidget {
  const FacultyPicker({super.key});

  @override
  State<FacultyPicker> createState() => _FacultyPickerState();
}

class _FacultyPickerState extends State<FacultyPicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SwipebarLayout(),
        PopButton(
          bottomPadding: 15,
          justText: true,
          onPress: () {
            context.read<HottestCubit>().loadPosts(selectedDate);
            Navigator.pop(context);
          },
          icon: CupertinoIcons.chevron_right,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.onSecondary,
          text: "Save selection",
        ),
        Expanded(
          child: InitScale(
            delayDurationInMilliseconds: 150,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  pickerTextStyle: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle,
                ),
              ),
              child: Center(
                child: CupertinoPicker(
                  selectionOverlay: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 3,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  // squeeze: 1.25,
                  looping: true,
                  itemExtent: 64,
                  onSelectedItemChanged: (_) => print("tap"),
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "XYZ the dog jumped over the lazy brown fox long text test here right now",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "XYZ the dog jumped over the lazy brown fox long text test here right now",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "XYZ the dog jumped over the lazy brown fox long text test here right now",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
