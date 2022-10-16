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
  });

  final SegementSelectorController controller;
  final Function(int) onTap;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: const BoxDecoration(
          color: Color(0xffF3F3F3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  AnimatedContainer(
                    curve: Curves.decelerate,
                    duration: const Duration(milliseconds: 350),
                    margin: EdgeInsets.only(left: (2 * constraints.maxWidth / 3) * widget.controller.value),
                    width: constraints.maxWidth / 3,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: const Color(0xff333333),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff333333).withOpacity(0.4),
                          blurRadius: 15,
                        ),
                      ],
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
                                    "School",
                                    key: const ValueKey("1-1"),
                                    style: kTitle.copyWith(
                                      color: const Color(0xffffffff),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "School",
                                    key: const ValueKey("1-2"),
                                    style: kTitle.copyWith(
                                      color: const Color(0xff333333),
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
                                    "Year",
                                    key: const ValueKey("2-1"),
                                    style: kTitle.copyWith(
                                      color: const Color(0xffffffff),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Year",
                                    key: const ValueKey("2-2"),
                                    style: kTitle.copyWith(
                                      color: const Color(0xff333333),
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
                                    "Faculty",
                                    key: const ValueKey("3-1"),
                                    style: kTitle.copyWith(
                                      color: const Color(0xffffffff),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Faculty",
                                    key: const ValueKey("3-2"),
                                    style: kTitle.copyWith(
                                      color: const Color(0xff333333),
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
