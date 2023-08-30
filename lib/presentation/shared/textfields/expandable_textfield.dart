import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
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
    this.verifiedUsersOnly = false,
    this.onChange,
    Key? key,
  }) : super(key: key);

  final bool verifiedUsersOnly;
  final Function(String value)? onChange;
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
                borderRadius: BorderRadius.all(
                    Radius.circular(Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: borderSize,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: TextField(
                          onChanged: (value) {
                            widget.verifiedUsersOnly
                                ? verifiedUserOnly(context, () => widget.onChange?.call(value),
                                    onFail: () => widget.controller.clear())
                                : widget.onChange?.call(value);
                          },
                          autofocus: false,
                          // onTap: () => focusNode.unfocus(),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
