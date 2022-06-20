import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class ErrorWithButtonText extends StatelessWidget {
  const ErrorWithButtonText({required this.onPress, this.text = "Connection Error", Key? key})
      : super(key: key);

  final VoidCallback onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: () => onPress(),
          child: Text(
            "try again",
            style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
