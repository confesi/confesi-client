import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class CommentHeaderText extends StatelessWidget {
  const CommentHeaderText({
    required this.header,
    required this.likes,
    required this.hates,
    required this.time,
    Key? key,
  }) : super(key: key);

  final String header;
  final int likes;
  final int hates;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '$time / ${largeNumberFormatter(likes - hates)}',
          style:
              kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
