import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class StickyAppbarController extends ChangeNotifier {
  // Making these variables private
  double offsetBuildback = 0.0;
  double stickyOffset = 0.0;
  late double stickyHeight;

  late AnimationController _animationController;
  Animation<double>? _offsetBuildbackAnimation;
  Animation<double>? _stickyOffsetAnimation;

  // Public getter for isAnimating
  bool isAnimating = false;

  StickyAppbarController(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 350),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward || status == AnimationStatus.reverse) {
          isAnimating = true;
        } else {
          isAnimating = false;
        }
        notifyListeners();
      });

    _animationController.addListener(_notifyListeners);
  }

  void cancelCurrentAnimation() {
    _animationController.stop();
  }

  void _initializeAnimation(double offsetStart, double offsetEnd, double stickyStart, double stickyEnd) {
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear, // linearToEaseOut
    );

    _offsetBuildbackAnimation = Tween<double>(begin: offsetStart, end: offsetEnd).animate(curvedAnimation)
      ..addListener(_notifyListeners);

    _stickyOffsetAnimation = Tween<double>(begin: stickyStart, end: stickyEnd).animate(curvedAnimation)
      ..addListener(_notifyListeners);
  }

  void _changeAnimationDuration(bool speedy) {
    Duration newDuration = speedy ? const Duration(milliseconds: 125) : const Duration(milliseconds: 350);
    _animationController.duration = newDuration;
  }

  void bringDownAppbar({bool speedy = false}) {
    _changeAnimationDuration(speedy);
    _initializeAnimation(offsetBuildback, stickyHeight, stickyOffset, 0);
    _animationController
      ..reset()
      ..forward();
  }

  void bringUpAppbar({bool speedy = false}) {
    _changeAnimationDuration(speedy);
    _initializeAnimation(offsetBuildback, 0, stickyOffset, stickyHeight);
    _animationController
      ..reset()
      ..forward();
  }

  void _notifyListeners() {
    if (_offsetBuildbackAnimation != null && _stickyOffsetAnimation != null) {
      offsetBuildback = _offsetBuildbackAnimation!.value;
      stickyOffset = _stickyOffsetAnimation!.value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(_notifyListeners);
    _animationController.dispose();
    super.dispose();
  }
}

class StickyAppbarProps {
  final double height;
  final Widget child;

  const StickyAppbarProps({required this.height, required this.child});
}

class StickyAppbar extends StatefulWidget {
  const StickyAppbar({super.key, required this.stickyHeader, required this.child, required this.controller});

  final StickyAppbarProps stickyHeader;
  final Widget child;
  final StickyAppbarController controller;

  @override
  State<StickyAppbar> createState() => _StickyAppbarState();
}

class _StickyAppbarState extends State<StickyAppbar> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.offsetBuildback = widget.stickyHeader.height; // Initial value
    widget.controller.stickyOffset = 0; // Initial value
    widget.controller.stickyHeight = widget.stickyHeader.height;
    widget.controller.addListener(() => setState(() {}));
  }

  bool currentlyScrolling = true;
  double lastScrollDelta = 0.0; // track the last scroll delta
  double offset = 0.0;
  double currScrollDelta = 0.0;
  double o = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification.metrics.axis == Axis.vertical) {
              setState(() {
                if (scrollNotification is ScrollStartNotification) {
                  currScrollDelta = 0;
                  currentlyScrolling = true;
                }
                if (scrollNotification is ScrollEndNotification) {
                  currentlyScrolling = false;
                  widget.controller.cancelCurrentAnimation();
                  if (widget.controller.offsetBuildback > widget.stickyHeader.height) return;
                  // Check if the scroll is not at the very top
                  if (lastScrollDelta < 0 && lastScrollDelta.abs() > 5) {
                    // Scrolling down
                    widget.controller.bringDownAppbar(speedy: true);
                  } else {
                    // Scrolling up
                    if (offset > widget.stickyHeader.height || currScrollDelta > 0) {
                      // widget.controller.bringUpAppbar(speedy: true);
                    } else {
                      widget.controller.bringDownAppbar(speedy: true);
                    }
                  }
                }
                if (scrollNotification is ScrollUpdateNotification) {
                  currScrollDelta += scrollNotification.scrollDelta!;
                  offset = scrollNotification.metrics.pixels;
                  if (widget.controller.isAnimating) return;
                  lastScrollDelta = scrollNotification.scrollDelta ?? 0.0;
                  if (scrollNotification.scrollDelta! > 0 && widget.controller.offsetBuildback > 0) {
                    widget.controller.offsetBuildback =
                        max(0, widget.controller.offsetBuildback - scrollNotification.scrollDelta!);
                  } else if (scrollNotification.scrollDelta! <= 0 &&
                      widget.controller.offsetBuildback < widget.stickyHeader.height) {
                    widget.controller.offsetBuildback = min(widget.stickyHeader.height,
                        widget.controller.offsetBuildback - scrollNotification.scrollDelta!);
                  }
                  widget.controller.stickyOffset = widget.stickyHeader.height - widget.controller.offsetBuildback;
                }
              });
            }
            return false;
          },
          child: widget.child,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: currentlyScrolling ? 0 : 210),
          top: min(-widget.controller.stickyOffset, o), // Use stickyOffset for positioning
          left: 0,
          right: 0,
          child: Opacity(
            opacity: min((3 * widget.controller.offsetBuildback) / widget.stickyHeader.height, 1),
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
