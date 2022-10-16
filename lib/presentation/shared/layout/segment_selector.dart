import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';

class SegementSelectorController extends ChangeNotifier {
  double value = 0.0;

  void toOne() {
    HapticFeedback.selectionClick();
    value = 0;
    notifyListeners();
  }

  void toTwo() {
    HapticFeedback.selectionClick();
    value = 0.5;
    notifyListeners();
  }

  void toThree() {
    HapticFeedback.selectionClick();
    value = 1;
    notifyListeners();
  }

  int valueToPage() {
    if (value <= 0.25) return 0;
    if (value <= 0.75) return 1;
    if (value == 1) return 2;
    throw Exception("Invalid value for page");
  }
}

class SegmentSelector extends StatefulWidget {
  const SegmentSelector({
    super.key,
    required this.controller,
    required this.onTap,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.backgroundColor,
    required this.selectedColor,
    required this.textColor,
  });

  final SegementSelectorController controller;
  final Function(int) onTap;
  final String text1;
  final String text2;
  final String text3;
  final Color backgroundColor;
  final Color selectedColor;
  final Color textColor;

  @override
  State<SegmentSelector> createState() => _SegmentSelectorState();
}

class _SegmentSelectorState extends State<SegmentSelector> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  double horizontalDragDelta = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        horizontalDragDelta = details.delta.dx;
      },
      onHorizontalDragEnd: (details) {
        if (horizontalDragDelta > 0) {
          if (widget.controller.value > .5) {
            widget.controller.toTwo();
          } else if (widget.controller.value > 0) {
            widget.controller.toOne();
          }
        }
        if (horizontalDragDelta < 0) {
          if (widget.controller.value < .5) {
            widget.controller.toTwo();
          } else if (widget.controller.value <= 0.5) {
            widget.controller.toThree();
          }
        }
        horizontalDragDelta = 0.0;
        widget.onTap(widget.controller.valueToPage());
      },
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  Center(
                    child: AnimatedContainer(
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 350),
                      margin: EdgeInsets.only(left: (2 * constraints.maxWidth / 3) * widget.controller.value),
                      width: constraints.maxWidth / 3,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: widget.selectedColor,
                        boxShadow: [
                          BoxShadow(
                            color: widget.selectedColor.withOpacity(0.4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.toOne();
                        widget.onTap(widget.controller.valueToPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        height: double.infinity,
                        // Transparent hitbox trick.
                        color: Colors.transparent,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: widget.controller.valueToPage() == 0
                                ? Text(
                                    widget.text1,
                                    key: const ValueKey("1-1"),
                                    style: kTitle.copyWith(
                                      color: widget.textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    widget.text1,
                                    key: const ValueKey("1-2"),
                                    style: kTitle.copyWith(
                                      color: widget.selectedColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.toTwo();
                        widget.onTap(widget.controller.valueToPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        height: double.infinity,
                        // Transparent hitbox trick.
                        color: Colors.transparent,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: widget.controller.valueToPage() == 1
                                ? Text(
                                    widget.text2,
                                    key: const ValueKey("2-1"),
                                    style: kTitle.copyWith(
                                      color: widget.textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    widget.text2,
                                    key: const ValueKey("2-2"),
                                    style: kTitle.copyWith(
                                      color: widget.selectedColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.toThree();
                        widget.onTap(widget.controller.valueToPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        height: double.infinity,
                        // Transparent hitbox trick.
                        color: Colors.transparent,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: widget.controller.valueToPage() == 2
                                ? Text(
                                    widget.text3,
                                    key: const ValueKey("3-1"),
                                    style: kTitle.copyWith(
                                      color: widget.textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    widget.text3,
                                    key: const ValueKey("3-2"),
                                    style: kTitle.copyWith(
                                      color: widget.selectedColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
