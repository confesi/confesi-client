import 'dart:math';

import 'package:flutter/material.dart';

class StickyAppbarProps {
  final double height;
  final Widget child;

  const StickyAppbarProps({required this.height, required this.child});
}

class StickyAppbar extends StatefulWidget {
  const StickyAppbar({super.key, required this.stickyHeader, required this.child});

  final StickyAppbarProps stickyHeader;
  final Widget child;

  @override
  State<StickyAppbar> createState() => _StickyAppbarState();
}

class _StickyAppbarState extends State<StickyAppbar> with SingleTickerProviderStateMixin {
  double offsetBuildback = 0.0;
  double stickyOffset = 0.0;

  @override
  void initState() {
    super.initState();
    offsetBuildback = widget.stickyHeader.height; // Initial value
    stickyOffset = 0; // Initial value
  }

  bool currentlyScrolling = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification.metrics.axis == Axis.vertical) {
              setState(() {
                if (scrollNotification is ScrollStartNotification) {
                  currentlyScrolling = true;
                }
                if (scrollNotification is ScrollUpdateNotification) {
                  if (scrollNotification.scrollDelta! > 0 && offsetBuildback > 0) {
                    offsetBuildback = max(0, offsetBuildback - scrollNotification.scrollDelta!);
                  } else if (scrollNotification.scrollDelta! <= 0 && offsetBuildback < widget.stickyHeader.height) {
                    offsetBuildback =
                        min(widget.stickyHeader.height, offsetBuildback - scrollNotification.scrollDelta!);
                  }
                  stickyOffset = widget.stickyHeader.height - offsetBuildback;
                }
              });
            } else if (scrollNotification.metrics.axis == Axis.horizontal) {
              setState(() {
                if (scrollNotification is ScrollStartNotification) {
                  currentlyScrolling = true;
                }
                if (scrollNotification is ScrollUpdateNotification) {
                  double newOffsetBuildback = offsetBuildback + scrollNotification.scrollDelta!.abs();
                  offsetBuildback = min(widget.stickyHeader.height, max(0, newOffsetBuildback));
                  stickyOffset = widget.stickyHeader.height - offsetBuildback;
                }
              });
            }
            return false;
          },
          child: widget.child,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: currentlyScrolling ? 0 : 125),
          top: -stickyOffset, // Use stickyOffset for positioning
          left: 0,
          right: 0,
          child: Opacity(
            opacity: offsetBuildback / widget.stickyHeader.height,
            child: SizedBox(
              height: widget.stickyHeader.height,
              child: widget.stickyHeader.child,
            ),
          ),
        ),
      ],
    );
  }
}
