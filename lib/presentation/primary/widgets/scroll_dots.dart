import 'package:flutter/material.dart';

class ScrollDots extends StatefulWidget {
  const ScrollDots({
    this.verticalPadding = 0.0,
    required this.pageLength,
    required this.pageIndex,
    required this.activeColor,
    required this.borderColor,
    required this.bgColor,
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int pageLength;
  final double verticalPadding;
  final Color borderColor;
  final Color activeColor;
  final Color bgColor;

  @override
  State<ScrollDots> createState() => _ScrollDotsState();
}

class _ScrollDotsState extends State<ScrollDots> {
  List<Widget> dots = [];

  List<Widget> createDots() {
    dots.clear();
    for (var i = 0; i < widget.pageLength; i++) {
      dots.add(
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: i == widget.pageIndex ? widget.activeColor : widget.bgColor,
            shape: BoxShape.circle,
            border: i == widget.pageIndex ? null : Border.all(color: widget.borderColor, width: 2),
          ),
        ),
      );
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageLength <= 1) {
      return Container(); // Return an empty container for 0 or 1 item
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: widget.verticalPadding),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: createDots(),
      ),
    );
  }
}
