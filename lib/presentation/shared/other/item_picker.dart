import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../behaviours/init_scale.dart';

class ItemPicker extends StatelessWidget {
  const ItemPicker({super.key, required this.options, required this.onChange});

  final List<String> options;
  final Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    return InitScale(
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
            looping: true,
            itemExtent: 64,
            onSelectedItemChanged: (index) => onChange(index),
            children: options.map((i) => _ItemPickerText(text: i)).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemPickerText extends StatelessWidget {
  const _ItemPickerText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          text,
          style: kBody.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
