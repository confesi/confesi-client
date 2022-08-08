import 'package:flutter/material.dart';

import '../../styles/typography.dart';

class ToolTip extends StatelessWidget {
  const ToolTip({required this.child, required this.message, Key? key})
      : super(key: key);

  final String? message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return message == null
        ? child
        : Tooltip(
            enableFeedback: true,
            textStyle: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  offset: const Offset(0, 0),
                  blurRadius: 80,
                ),
              ],
            ),
            message: message,
            child: child,
          );
  }
}
