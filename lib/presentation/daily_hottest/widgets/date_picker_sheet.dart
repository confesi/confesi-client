import 'package:Confessi/presentation/daily_hottest/widgets/date_picker.dart';

import 'package:flutter/material.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/layout/swipebar.dart';

Future<dynamic> showDatePickerSheet(BuildContext context) async {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SwipebarLayout(),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: bottomSafeArea(context), top: 30, left: 15, right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Builder(builder: (context) {
              return const DatePicker();
            }),
          ),
        ),
      ],
    ),
  );
}
