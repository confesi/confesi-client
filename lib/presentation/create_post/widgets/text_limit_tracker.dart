import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';

class TextLimitTracker extends StatelessWidget {
  const TextLimitTracker({
    required this.value,
    Key? key,
  }) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            backgroundColor: Theme.of(context).colorScheme.shadow,
            color: value >= 1
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            value: value,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: value >= 1
              ? Text(
                  'Limit reached!',
                  key: const ValueKey('limit'),
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  'Character limit',
                  key: const ValueKey('valid'),
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
        )
      ],
    );
  }
}
