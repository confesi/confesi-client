import 'package:flutter/material.dart';

import '../../constants/typography.dart';
import '../layouts/line.dart';

class RowWithBorderText extends StatelessWidget {
  const RowWithBorderText({required this.leftText, required this.rightText, Key? key})
      : super(key: key);

  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                leftText,
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              rightText,
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LineLayout(color: Theme.of(context).colorScheme.onBackground),
        const SizedBox(height: 20),
      ],
    );
  }
}
