import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          text,
          style:
              kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
