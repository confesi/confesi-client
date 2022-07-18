import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/typography.dart';

class BulgeTextField extends StatefulWidget {
  const BulgeTextField(
      {this.hintText = "Search",
      required this.controller,
      this.icon = CupertinoIcons.search,
      this.bottomPadding = 0.0,
      this.topPadding = 0.0,
      this.horizontalPadding = 0.0,
      this.password = false,
      Key? key})
      : super(key: key);

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
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 24,
                  child: Center(
                    child: TextField(
                      obscureText: widget.password,
                      // scrollPadding: const EdgeInsets.all(0),
                      focusNode: focusNode,
                      controller: widget.controller,
                      style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: "...",
                        hintStyle: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
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
