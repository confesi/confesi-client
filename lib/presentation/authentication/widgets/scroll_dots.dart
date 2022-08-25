import 'package:flutter/material.dart';

class ScrollDots extends StatefulWidget {
  const ScrollDots({
    this.verticalPadding = 0.0,
    required this.pageLength,
    required this.pageIndex,
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int pageLength;
  final double verticalPadding;

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
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              border: i == widget.pageIndex
                  ? null
                  : Border.all(
                      color: Theme.of(context).colorScheme.onSecondary,
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
      padding: EdgeInsets.symmetric(
          horizontal: 30, vertical: widget.verticalPadding),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: createDots(),
      ),
    );
  }
}
