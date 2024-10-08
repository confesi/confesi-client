import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/haptics/haptics.dart';

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
    this.rightIconLoading = false,
    this.leftIconIgnored = false,
    this.leftIconTag,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final bool rightIconLoading;
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
              Haptics.f(H.regular);
              widget.leftIconOnPress!();
            } else {
              // Haptics.f(H.regular);
              FocusScope.of(context).unfocus();
              router.pop();
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Opacity(
                opacity: widget.leftIconDisabled ? 0.2 : 1,
                child: Icon(
                  widget.leftIcon ?? CupertinoIcons.arrow_left,
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildRightLoading() => Padding(
        key: const ValueKey("buildRightLoading"),
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.primary),
        ),
      );

  Widget buildRightIcon() => TouchableOpacity(
        key: const ValueKey("buildRightIcon"),
        onTap: () {
          if (widget.rightIconOnPress != null) {
            FocusScope.of(context).unfocus();
            Haptics.f(H.regular);
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
      );

  Widget buildRightSide() {
    if (widget.rightIconVisible && !widget.rightIconLoading) {
      return buildRightIcon();
    } else if (widget.rightIconLoading) {
      return buildRightLoading();
    } else {
      return Padding(
        key: const ValueKey("rightIcon"),
        padding: const EdgeInsets.all(15),
        child: Icon(widget.rightIcon ?? CupertinoIcons.arrow_clockwise, color: Colors.transparent),
      );
    }
  }

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
              width: borderSize,
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: buildRightSide(),
            ),
          ],
        ),
      ),
    );
  }
}
