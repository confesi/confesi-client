import 'package:flutter/material.dart';

class SwipebarLayout extends StatelessWidget {
  const SwipebarLayout({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.onBackground,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
