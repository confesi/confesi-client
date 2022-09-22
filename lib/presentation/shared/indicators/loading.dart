import 'dart:math';

import 'package:Confessi/presentation/shared/behaviours/init_enlarger.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.color,
    Key? key,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InitScale(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              CircularProgressIndicator(
                strokeWidth: 2.5,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Transform.rotate(
                  angle: pi /
                      2, // Gives the inner spinner a 90 degree offset relative to the parent.
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: color ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
