import 'package:flutter/material.dart';

class ScrollDotsLayout extends StatefulWidget {
  const ScrollDotsLayout(
      {this.verticalPadding = 0.0, required this.pageLength, required this.pageIndex, Key? key})
      : super(key: key);

  final int pageIndex;
  final int pageLength;
  final double verticalPadding;

  @override
  State<ScrollDotsLayout> createState() => _ScrollDotsLayoutState();
}

class _ScrollDotsLayoutState extends State<ScrollDotsLayout> {
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
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              border: i == widget.pageIndex
                  ? null
                  : Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
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
