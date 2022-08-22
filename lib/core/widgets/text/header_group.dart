import 'package:flutter/material.dart';

import '../../styles/typography.dart';

class HeaderGroupText extends StatelessWidget {
  const HeaderGroupText({
    this.left = false,
    required this.header,
    required this.body,
    Key? key,
  }) : super(key: key);

  final String header;
  final String body;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          left ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          header,
          style: kDisplay.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          textAlign: left ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          body,
          style: kTitle.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          textAlign: left ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
