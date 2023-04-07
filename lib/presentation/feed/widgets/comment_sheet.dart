import '../../shared/other/text_limit_tracker.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/textfields/expandable_textfield.dart';

class CommentSheetController extends ChangeNotifier {
  bool _blockingInteraction = false;
  late TextEditingController commentController;
  late FocusNode textFocusNode;

  void _init(TextEditingController commentController, FocusNode textFocusNode) {
    this.commentController = commentController;
    this.textFocusNode = textFocusNode;
  }

  bool get isBlocking => _blockingInteraction;

  void setBlocking(bool isBlocking) {
    textFocusNode.unfocus();
    _blockingInteraction = isBlocking;
    notifyListeners();
  }

  void focus() {
    textFocusNode.requestFocus();
    notifyListeners();
  }

  void unfocus() {
    textFocusNode.unfocus();
    notifyListeners();
  }

  void delete() {
    textFocusNode.unfocus();
    commentController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    commentController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }
}

class CommentSheet extends StatefulWidget {
  const CommentSheet({
    required this.onSubmit,
    required this.maxCharacters,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final CommentSheetController controller;
  final int maxCharacters;
  final Function(String) onSubmit;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();

  @override
  void initState() {
    widget.controller._init(commentController, textFocusNode);
    widget.controller.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.controller.isBlocking,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandableTextfield(
              focusNode: textFocusNode,
              hintText: "What's your take?",
              maxLines: 4,
              minLines: 1,
              maxCharacters: widget.maxCharacters,
              onChanged: (_) => setState(() => {}),
              controller: commentController,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: commentController.text.isEmpty
                    ? Container()
                    : AnimatedScale(
                        scale: commentController.text.isEmpty ? 0 : 1,
                        duration: const Duration(milliseconds: 100),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              SimpleTextButton(
                                tooltipLocation: TooltipLocation.above,
                                text: 'Cancel',
                                isErrorText: true,
                                onTap: () => widget.controller.delete(),
                              ),
                              Expanded(
                                child: TextLimitTracker(
                                  noText: false,
                                  value: commentController.text.runes.length / widget.maxCharacters,
                                ),
                              ),
                              SimpleTextButton(
                                tapType: TapType.strongImpact,
                                tooltipLocation: TooltipLocation.above,
                                text: 'Post',
                                onTap: () {
                                  widget.onSubmit(commentController.text);
                                  setState(() => {});
                                },
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
