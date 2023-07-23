import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
    this.verticalPadding = true,
    this.textFactor1 = false,
  });

  final String text;
  final bool verticalPadding;
  final bool textFactor1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ? 15 : 0),
      child: Text(
        text,
        style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
        textScaleFactor: textFactor1 ? 1 : null,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        textAlign: TextAlign.left,
      ),
    );
  }
}
