import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class BulgeTextField extends StatefulWidget {
  const BulgeTextField(
      {this.hintText = "Search",
      required this.controller,
      this.icon = CupertinoIcons.search,
      this.bottomPadding = 0.0,
      this.topPadding = 0.0,
      this.horizontalPadding = 0.0,
      this.password = false,
      this.autoCorrect = false,
      Key? key})
      : super(key: key);

  final bool autoCorrect;
  final bool password;
  final IconData icon;
  final double bottomPadding;
  final String hintText;
  final double topPadding;
  final double horizontalPadding;
  final TextEditingController controller;

  @override
  State<BulgeTextField> createState() => _BulgeTextFieldState();
}

class _BulgeTextFieldState extends State<BulgeTextField> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    widget.controller.clear();
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
          Text(
            widget.hintText,
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => focusNode.requestFocus(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: .5,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 24,
                  child: Center(
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
                        hintText: "...",
                        hintStyle: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
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
