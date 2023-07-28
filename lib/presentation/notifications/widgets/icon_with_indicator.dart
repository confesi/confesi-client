import 'package:flutter/material.dart';

class IconWithIndicator extends StatelessWidget {
  const IconWithIndicator({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }
}
