import 'date_picker.dart';

import 'package:flutter/material.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';

Future<dynamic> showDatePickerSheet(BuildContext context) async {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: bottomSafeArea(context), left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Theme.of(context).colorScheme.background,
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
