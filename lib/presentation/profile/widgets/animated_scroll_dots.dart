import 'package:flutter/material.dart';

class AnimatedScrollDots extends StatefulWidget {
  const AnimatedScrollDots({
    this.verticalPadding = 0.0,
    required this.pageLength,
    required this.pageIndex,
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int pageLength;
  final double verticalPadding;

  @override
  State<AnimatedScrollDots> createState() => _AnimatedScrollDotsState();
}

class _AnimatedScrollDotsState extends State<AnimatedScrollDots> {
  final bool on = false;
  List<_Dot> dots = [];

  List<_Dot> createDots() {
    setState(() {
      dots.clear();
      for (var i = 0; i < widget.pageLength; i++) {
        dots.add(_Dot(
          currentPage: i,
          pageIndex: widget.pageIndex,
        ));
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

class _Dot extends StatefulWidget {
  const _Dot({
    required this.pageIndex,
    required this.currentPage,
  });

  final int pageIndex;
  final int currentPage;

  @override
  State<_Dot> createState() => __DotState();
}

class __DotState extends State<_Dot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: widget.currentPage == widget.pageIndex
            ? Theme.of(context).colorScheme.onSecondary
            : Colors.transparent,
        shape: BoxShape.circle,
        border: widget.currentPage == widget.pageIndex
            ? null
            : Border.all(
                color: Theme.of(context).colorScheme.onSecondary, width: 2),
      ),
    );
  }
}
