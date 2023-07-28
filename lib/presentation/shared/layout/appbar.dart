import '../../../core/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../button_touch_effects/touchable_opacity.dart';

/// If [leftIconOnPress] is null, defaults to popping current context.
class AppbarLayout extends StatefulWidget {
  const AppbarLayout({
    this.leftIcon,
    this.rightIcon,
    this.leftIconOnPress,
    this.rightIconOnPress,
    this.bottomBorder = false,
    this.leftIconVisible = true,
    this.rightIconVisible = false,
    required this.centerWidget,
    this.leftIconDisabled = false,
    this.leftIconIgnored = false,
    this.leftIconTag,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final String? leftIconTag;
  final bool leftIconIgnored;
  final Widget centerWidget;
  final bool leftIconVisible;
  final bool rightIconVisible;
  final bool bottomBorder;
  final IconData? leftIcon;
  final Function? leftIconOnPress;
  final IconData? rightIcon;
  final Function? rightIconOnPress;
  final bool leftIconDisabled;
  final Color? backgroundColor;

  @override
  State<AppbarLayout> createState() => _AppbarLayoutState();
}

class _AppbarLayoutState extends State<AppbarLayout> {
  Widget buildLeftWidget(BuildContext context) => IgnorePointer(
        ignoring: widget.leftIconDisabled || widget.leftIconIgnored,
        child: TouchableOpacity(
          onTap: () {
            if (widget.leftIconOnPress != null) {
              FocusScope.of(context).unfocus();
              widget.leftIconOnPress!();
            } else {
              FocusScope.of(context).unfocus();
              router.pop();
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Transform.translate(
                  offset: const Offset(-4, 0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: widget.leftIconDisabled ? 0.2 : 1,
                    child: Icon(
                      widget.leftIcon ?? CupertinoIcons.arrow_left,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
          border: Border(
            bottom: BorderSide(
              color: widget.bottomBorder ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
              width: .8,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.leftIconVisible)
              widget.leftIconTag != null
                  ? Hero(tag: widget.leftIconTag!, child: buildLeftWidget(context))
                  : buildLeftWidget(context)
            else
              Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(widget.rightIcon ?? CupertinoIcons.arrow_clockwise, color: Colors.transparent),
              ),
            Expanded(
              child: Center(
                child: widget.centerWidget,
              ),
            ),
            if (widget.rightIconVisible)
              TouchableOpacity(
                onTap: () {
                  if (widget.rightIconOnPress != null) {
                    FocusScope.of(context).unfocus();
                    widget.rightIconOnPress!();
                  }
                },
                child: Container(
                  // Transparent hitbox trick.
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        widget.rightIcon,
                      ),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(widget.rightIcon ?? CupertinoIcons.arrow_clockwise, color: Colors.transparent),
              ),
          ],
        ),
      ),
    );
  }
}
