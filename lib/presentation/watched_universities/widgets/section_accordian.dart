import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/animated_cliprrect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/button_touch_effects/touchable_scale.dart';

class DrawerUniversityTile extends StatelessWidget {
  const DrawerUniversityTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.onSwipe,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final VoidCallback? onSwipe;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => onTap(),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 10),
              isLoading
                  ? CupertinoActivityIndicator(color: Theme.of(context).colorScheme.primary)
                  : Icon(
                      CupertinoIcons.arrow_right,
                      size: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionAccordian extends StatefulWidget {
  const SectionAccordian({
    Key? key,
    this.startsOpen = true,
    required this.items,
    required this.title,
    this.topBorder = false,
    this.bottomBorder = false,
  }) : super(key: key);

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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                      key: isOpen ? const ValueKey("open") : const ValueKey("closed"),
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
            child: Column(
              children: widget.items.map((item) {
                return item.onSwipe != null
                    ? Dismissible(
                        key: UniqueKey(), // Use a unique key for each item
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          // Call the onSwipe callback if it's provided
                          HapticFeedback.lightImpact();
                          item.onSwipe?.call();
                          setState(() {
                            widget.items.remove(item);
                          });
                        },
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),
                        ),
                        child: TouchableScale(
                          onTap: item.onTap,
                          child: item, // The DrawerUniversityTile
                        ),
                      )
                    : item;
              }).toList(),
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
