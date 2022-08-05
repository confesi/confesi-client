import 'package:flutter/material.dart';

import '../../styles/typography.dart';

class GroupText extends StatelessWidget {
  const GroupText({
    required this.body,
    required this.header,
    this.leftAlign = false,
    this.small = false,
    Key? key,
  }) : super(key: key);

  final String header;
  final String body;
  final bool leftAlign;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: leftAlign ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          header,
          style: small
              ? kTitle.copyWith(color: Theme.of(context).colorScheme.primary)
              : kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: leftAlign ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          body,
          style: small
              ? kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface)
              : kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
          textAlign: leftAlign ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
