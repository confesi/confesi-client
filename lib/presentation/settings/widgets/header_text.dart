import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
    this.verticalPadding = true,
  });

  final String text;
  final bool verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ? 10 : 0),
      child: Text(
        text,
        style: kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        textAlign: TextAlign.left,
      ),
    );
  }
}
