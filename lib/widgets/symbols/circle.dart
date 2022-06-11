import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleSymbol extends StatelessWidget {
  const CircleSymbol({this.radius = 38, Key? key}) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.flame,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }
}
