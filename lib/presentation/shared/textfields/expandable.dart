import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ExpandableTextfield extends StatefulWidget {
  const ExpandableTextfield({
    required this.controller,
    required this.onChanged,
    this.maxCharacters,
    this.minLines,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String) onChanged;
  final int? maxCharacters;
  final int? minLines;
  final int? maxLines;

  @override
  State<ExpandableTextfield> createState() => _ExpandableTextfieldState();
}

class _ExpandableTextfieldState extends State<ExpandableTextfield> {
  FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.controller.clear();
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
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CupertinoScrollbar(
            controller: scrollController,
            child: TextField(
              scrollController: scrollController,
              // maxLength: widget.maxCharacters,
              onChanged: (value) => widget.onChanged(value),
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              keyboardType: TextInputType.multiline,
              focusNode: focusNode,
              controller: widget.controller,
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              decoration: InputDecoration.collapsed(
                hintText: "What's your take?",
                hintStyle: kBody.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
