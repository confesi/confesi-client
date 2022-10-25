import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class DisclaimerText extends StatelessWidget {
  const DisclaimerText({
    Key? key,
    required this.text,
    this.verticalPadding = 0,
    this.textScaleFactor1 = false,
  }) : super(key: key);

  final String text;
  final double verticalPadding;
  final bool textScaleFactor1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  text,
                  textScaleFactor: textScaleFactor1 ? 1 : null,
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
