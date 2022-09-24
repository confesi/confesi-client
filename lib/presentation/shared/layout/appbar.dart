import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../behaviours/touchable_opacity.dart';

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
    this.centerWidgetFullWidth = false,
    this.leftIconDisabled = false,
    this.leftIconIgnored = false,
    this.leftIconTag,
    Key? key,
  }) : super(key: key);

  final String? leftIconTag;
  final bool centerWidgetFullWidth;
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
              Navigator.pop(context);
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
                      widget.leftIcon ?? CupertinoIcons.back,
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
      color: Theme.of(context).colorScheme.background,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.bottomBorder
                  ? Theme.of(context).colorScheme.shadow
                  : Colors.transparent,
              width: .7,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.leftIconVisible)
              widget.leftIconTag != null
                  ? Hero(
                      tag: widget.leftIconTag!, child: buildLeftWidget(context))
                  : buildLeftWidget(context)
            else
              Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(widget.rightIcon ?? CupertinoIcons.arrow_clockwise,
                    color: Colors.transparent),
              ),
            Flexible(
              child: widget.centerWidget,
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
                child: Icon(widget.rightIcon ?? CupertinoIcons.arrow_clockwise,
                    color: Colors.transparent),
              ),
          ],
        ),
      ),
    );
  }
}
