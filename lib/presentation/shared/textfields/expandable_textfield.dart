import 'package:flutter/services.dart';

import '../behaviours/init_scale.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ExpandableTextfield extends StatefulWidget {
  const ExpandableTextfield({
    required this.controller,
    required this.hintText,
    this.maxCharacters,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.padding,
    this.color,
    this.obscured = false,
    this.autoCorrectAndCaps = true,
    this.keyboardType = TextInputType.text,
    this.enableSuggestions = false,
    Key? key,
  }) : super(key: key);

  final bool enableSuggestions;
  final TextInputType keyboardType;
  final bool autoCorrectAndCaps;
  final bool obscured;
  final EdgeInsets? padding;
  final TextEditingController controller;
  final int? maxCharacters;
  final int? minLines;
  final int? maxLines;
  final String hintText;
  final FocusNode? focusNode;
  final Color? color;

  @override
  State<ExpandableTextfield> createState() => _ExpandableTextfieldState();
}

class _ExpandableTextfieldState extends State<ExpandableTextfield> {
  FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool isDisposed = false;
  @override
  void initState() {
    widget.controller.clear();
    widget.controller.addListener(() {
      if (isDisposed) return;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    isDisposed = true;
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.color ?? Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.8,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: CupertinoScrollbar(
                thumbVisibility: widget.maxLines == 1 ? false : true,
                thickness: widget.maxLines == 1 ? 0.0 : 3.0, // 3.0 is default
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          enableSuggestions: widget.enableSuggestions,
                          obscureText: widget.obscured,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(widget.maxCharacters),
                          ],
                          maxLengthEnforcement: MaxLengthEnforcement.enforced, // keep enforcement enabled
                          scrollController: scrollController,
                          autocorrect: widget.autoCorrectAndCaps,
                          textCapitalization:
                              widget.autoCorrectAndCaps ? TextCapitalization.sentences : TextCapitalization.none,
                          maxLines: widget.maxLines,
                          minLines: widget.minLines,
                          keyboardType: widget.keyboardType,
                          focusNode: widget.focusNode ?? focusNode,
                          controller: widget.controller,
                          style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration.collapsed(
                            hintText: widget.hintText,
                            hintStyle: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
