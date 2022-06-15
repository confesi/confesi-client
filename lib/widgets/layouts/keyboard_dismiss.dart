import 'package:flutter/material.dart';

class KeyboardDismissLayout extends StatelessWidget {
  const KeyboardDismissLayout({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onVerticalDragUpdate: (details) {
        if (details.delta.direction > 0 && details.delta.distance > 20) {
          FocusScope.of(context).unfocus();
        }
      },
      child: child,
    );
  }
}
