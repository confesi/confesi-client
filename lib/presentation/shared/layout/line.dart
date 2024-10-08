import 'package:confesi/constants/shared/constants.dart';
import 'package:flutter/material.dart';

class LineLayout extends StatelessWidget {
  const LineLayout({
    this.horizontalPadding = 0.0,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
    required this.color,
    this.width = double.infinity,
    Key? key,
  }) : super(key: key);

  final Color color;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: topPadding, bottom: bottomPadding),
      child: Container(
        height: borderSize,
        width: width,
        color: color,
      ),
    );
  }
}
