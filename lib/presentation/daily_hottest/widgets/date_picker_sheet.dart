import 'package:Confessi/presentation/daily_hottest/widgets/date_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../dependency_injection.dart';

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
          child: Builder(builder: (context) {
            return const DatePicker();
          }),
        ),
      ),
    ),
  );
}
