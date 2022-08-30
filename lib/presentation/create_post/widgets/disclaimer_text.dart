import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class DisclaimerText extends StatelessWidget {
  const DisclaimerText({
    Key? key,
    required this.text,
    this.topPadding = 15,
  }) : super(key: key);

  final String text;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: IntrinsicHeight(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  text,
                  style: kBody.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
