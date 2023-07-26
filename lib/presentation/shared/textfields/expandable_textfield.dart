import 'package:flutter/services.dart';

import '../behaviours/init_scale.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ExpandableTextfield extends StatefulWidget {
  const ExpandableTextfield({
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.maxCharacters,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.padding,
    this.color,
    this.obscured = false,
    this.autoCorrectAndCaps = true,
    Key? key,
  }) : super(key: key);

  final bool autoCorrectAndCaps;
  final bool obscured;
  final EdgeInsets? padding;
  final TextEditingController controller;
  final Function(String) onChanged;
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

  @override
  void initState() {
    widget.controller.clear();
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          widget.focusNode != null ? widget.focusNode?.requestFocus() : focusNode.requestFocus();
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.color ?? Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
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
                            obscureText: widget.obscured,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(widget.maxCharacters),
                            ],
                            maxLengthEnforcement: MaxLengthEnforcement.enforced, // keep enforcement enabled
                            scrollController: scrollController,
                            autocorrect: widget.autoCorrectAndCaps,
                            textCapitalization:
                                widget.autoCorrectAndCaps ? TextCapitalization.sentences : TextCapitalization.none,
                            // maxLength: widget.maxCharacters,
                            onChanged: (value) => widget.onChanged(value),
                            maxLines: widget.maxLines,
                            minLines: widget.minLines,
                            keyboardType: TextInputType.multiline,
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
      ),
    );
  }
}
