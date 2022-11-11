import '../../../core/styles/typography.dart';
import 'package:flutter/material.dart';

class TextSeparator extends StatelessWidget {
  const TextSeparator({
    super.key,
    required this.text,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
  });

  final String text;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 3),
              height: 1,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
