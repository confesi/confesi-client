import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class ErrorWithButtonText extends StatelessWidget {
  const ErrorWithButtonText(
      {this.buttonText = "try again",
      required this.onPress,
      this.headerText = "Connection Error",
      Key? key})
      : super(key: key);

  final VoidCallback onPress;
  final String headerText;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          headerText,
          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: () => onPress(),
          child: Text(
            buttonText,
            style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
