import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class BulgeTextField extends StatefulWidget {
  const BulgeTextField(
      {this.topText = "Search",
      required this.controller,
      this.icon = CupertinoIcons.search,
      this.bottomPadding = 0.0,
      this.topPadding = 0.0,
      this.horizontalPadding = 0.0,
      this.password = false,
      this.autoCorrect = false,
      this.showTopText = true,
      this.hintText,
      this.onFocusChange,
      this.hasRightButton = false,
      this.rightButtonOnTap,
      this.rightButtonText,
      Key? key})
      : super(key: key);

  final Function(bool)? onFocusChange;
  final String? hintText;
  final bool showTopText;
  final bool autoCorrect;
  final bool password;
  final IconData icon;
  final double bottomPadding;
  final String topText;
  final double topPadding;
  final double horizontalPadding;
  final TextEditingController controller;
  final bool hasRightButton;
  final VoidCallback? rightButtonOnTap;
  final String? rightButtonText;

  @override
  State<BulgeTextField> createState() => _BulgeTextFieldState();
}

class _BulgeTextFieldState extends State<BulgeTextField> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // widget.controller.clear();
    focusNode.addListener(() {
      if (widget.onFocusChange == null) return;
      if (focusNode.hasFocus) {
        widget.onFocusChange!(true);
      } else {
        widget.onFocusChange!(false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.horizontalPadding,
          right: widget.horizontalPadding,
          top: widget.topPadding,
          bottom: widget.bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showTopText
              ? Column(
                  children: [
                    Text(
                      widget.topText,
                      style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : Container(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => focusNode.requestFocus(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .5,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 17.5, bottom: 17.5, left: 17.5),
                            child: TextField(
                              enableSuggestions: false,
                              autocorrect: widget.autoCorrect,
                              obscureText: widget.password,
                              focusNode: focusNode,
                              controller: widget.controller,
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: widget.hintText ?? "...",
                                hintStyle: kBody.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TouchableOpacity(
                          onTap: () => widget.controller.clear(),
                          child: Container(
                            // Transparent hitbox trick.
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(17.5),
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  if (widget.rightButtonOnTap != null) {
                    widget.rightButtonOnTap!();
                  }
                },
                child: Container(
                  // Transparent hitbox trick.
                  height: 48,
                  color: Colors.transparent,
                  child: AnimatedSize(
                    curve: Curves.decelerate,
                    duration: const Duration(milliseconds: 175),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.hasRightButton ? 15 : 0),
                      child: Center(
                        child: Text(
                          widget.hasRightButton
                              ? widget.rightButtonText != null
                                  ? widget.rightButtonText!
                                  : throw "Please enter right button text."
                              : "",
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
