import 'package:flutter/material.dart';

import '../../styles/typography.dart';

class HeaderGroupText extends StatelessWidget {
  const HeaderGroupText({this.dark = false, required this.header, required this.body, Key? key})
      : super(key: key);

  final String header;
  final String body;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          header,
          style: kDisplay.copyWith(color: Theme.of(context).colorScheme.background),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          body,
          style: kTitle.copyWith(
              color: dark
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
