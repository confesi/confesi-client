import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class ScrollableButton extends StatelessWidget {
  const ScrollableButton({required this.text, required this.onPress, Key? key}) : super(key: key);

  final VoidCallback onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
        child: TextButton(
          onPressed: () => onPress(),
          child: Text(
            text,
            style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
