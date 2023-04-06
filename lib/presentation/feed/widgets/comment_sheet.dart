import 'package:Confessi/core/utils/sizing/width_fraction.dart';

import '../../shared/other/text_limit_tracker.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/textfields/expandable_textfield.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({
    required this.onSubmit,
    required this.maxCharacters,
    Key? key,
  }) : super(key: key);

  final int maxCharacters;
  final Function(String) onSubmit;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpandableTextfield(
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
              duration: const Duration(milliseconds: 100),
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
                              onTap: () {
                                commentController.clear();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            Expanded(
                              child: TextLimitTracker(
                                noText: false,
                                value: commentController.text.length / widget.maxCharacters,
                              ),
                            ),
                            SimpleTextButton(
                              tapType: TapType.strongImpact,
                              tooltipLocation: TooltipLocation.above,
                              text: 'Post',
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                widget.onSubmit(commentController.text);
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
    );
  }
}
