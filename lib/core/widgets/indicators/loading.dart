import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.color,
    Key? key,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(10),
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
