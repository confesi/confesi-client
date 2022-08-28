import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class DisclaimerText extends StatelessWidget {
  const DisclaimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          // Container(
          //   color: Theme.of(context).colorScheme.secondary,
          //   width: 1,
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'Please be civil, but have fun. All posts are completely anonymous (excluding above details).',
                style: kBody.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
