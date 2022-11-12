import 'package:flutter/material.dart';

class ScrollDots extends StatefulWidget {
  const ScrollDots({
    this.verticalPadding = 0.0,
    required this.pageLength,
    required this.pageIndex,
    this.secondaryColors = false,
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int pageLength;
  final double verticalPadding;
  final bool secondaryColors;

  @override
  State<ScrollDots> createState() => _ScrollDotsState();
}

class _ScrollDotsState extends State<ScrollDots> {
  final bool on = false;
  List<Widget> dots = [];

  List<Widget> createDots() {
    setState(() {
      dots.clear();
      for (var i = 0; i < widget.pageLength; i++) {
        dots.add(
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: i == widget.pageIndex
                  ? widget.secondaryColors
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSecondary
                  : widget.secondaryColors
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onSurface,
              shape: BoxShape.circle,
              border: i == widget.pageIndex
                  ? null
                  : Border.all(
                      color: widget.secondaryColors
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSecondary,
                      width: 2),
            ),
          ),
        );
      }
    });
    return dots;
  }

  @override
  Widget build(BuildContext context) {
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
