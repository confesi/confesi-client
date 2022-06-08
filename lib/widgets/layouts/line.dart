import 'package:flutter/material.dart';

class LineLayout extends StatelessWidget {
  const LineLayout({required this.color, Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      width: double.infinity,
      color: color,
    );
  }
}
