import 'package:Confessi/presentation/shared/other/item_picker.dart';
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
          child: ItemPicker(
            onChange: (index) => print(index),
            options: ["Option 1", "Option 2", "Option 3"],
          ),
        ),
      ],
    );
  }
}
