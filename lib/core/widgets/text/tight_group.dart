import 'package:flutter/material.dart';

import '../../styles/typography.dart';

class TightGroupText extends StatelessWidget {
  const TightGroupText({
    required this.header,
    required this.body,
    Key? key,
  }) : super(key: key);

  final String header;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.primary, fontSize: 14),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          body,
          style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
