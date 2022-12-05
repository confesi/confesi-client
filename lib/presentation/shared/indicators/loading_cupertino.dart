import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingCupertinoIndicator extends StatelessWidget {
  const LoadingCupertinoIndicator({
    this.color,
    Key? key,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      // TODO: Wrap with an initScale?
      fit: BoxFit.scaleDown,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CupertinoActivityIndicator(
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
