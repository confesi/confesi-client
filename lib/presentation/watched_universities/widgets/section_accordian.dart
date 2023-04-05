import 'dart:isolate';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/animated_cliprrect.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';
import 'searched_university_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawer_university_tile.dart';

class SectionAccordian extends StatefulWidget {
  const SectionAccordian({
    super.key,
    this.startsOpen = true,
    required this.items,
    required this.title,
    this.topBorder = false,
    this.bottomBorder = false,
  });

  final String title;
  final bool startsOpen;
  final List<DrawerUniversityTile> items;
  final bool topBorder;
  final bool bottomBorder;

  @override
  State<SectionAccordian> createState() => _SectionAccordianState();
}

class _SectionAccordianState extends State<SectionAccordian> {
  late bool isOpen;

  @override
  void initState() {
    isOpen = widget.startsOpen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: widget.topBorder
                ? Border(
                    top: BorderSide(
                      width: 0.8,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  )
                : null,
          ),
          child: TouchableScale(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                // Transparent hitbox trick
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 5),
                  AnimatedSwitcher(
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    duration: const Duration(milliseconds: 100),
                    child: Icon(
                      isOpen ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_right,
                      key: UniqueKey(),
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: AnimatedClipRect(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 150),
            reverseDuration: const Duration(milliseconds: 150),
            alignment: Alignment.bottomCenter,
            horizontalAnimation: false,
            open: isOpen,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: widget.items.isEmpty // If there are no passed items, show a friendly error text.
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 10),
                        child: Text(
                          "Uh oh, nothing here.",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                  : Column(
                      children: widget.items,
                    ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: widget.bottomBorder
                ? Border(
                    bottom: BorderSide(
                      width: 0.8,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
