import '../../../core/styles/typography.dart';
import 'package:flutter/material.dart';

class TextLimitTracker extends StatelessWidget {
  const TextLimitTracker({
    required this.value,
    this.noText = false,
    Key? key,
  }) : super(key: key);

  final double value;
  final bool noText;

  String getText() {
    if (value >= 1) {
      return "Limit reached";
    } else if (value > .7) {
      return "Slow down...";
    } else {
      return "Character limit";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            color: value >= 1
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            value: value,
          ),
        ),
        noText
            ? Container()
            : Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    'Limit',
                    key: UniqueKey(),
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
      ],
    );
  }
}
