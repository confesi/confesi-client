import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class SpreadRowText extends StatelessWidget {
  const SpreadRowText({
    required this.leftText,
    required this.rightText,
    Key? key,
  }) : super(key: key);

  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leftText,
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              rightText,
              maxLines: 5,
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
