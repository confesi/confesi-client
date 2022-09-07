import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/presentation/create_post/widgets/text_limit_tracker.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/textfields/expandable.dart';

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

class _CommentSheetState extends State<CommentSheet>
    with TickerProviderStateMixin {
  final TextEditingController commentController = TextEditingController();

  late AnimationController showAnimController;
  late Animation showAnim;

  late AnimationController popAnimController;
  late Animation popAnim;

  int commentLength = 0;

  @override
  void initState() {
    showAnimController = AnimationController(
      value: 1.0,
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    showAnim =
        CurvedAnimation(parent: showAnimController, curve: Curves.linear);
    popAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    popAnim = CurvedAnimation(parent: popAnimController, curve: Curves.linear);
    super.initState();
  }

  void manageAnim() {
    setState(() {});
    if (commentController.text.isEmpty) {
      popAnimController.reverse();
      showAnimController.forward();
    } else {
      showAnimController.reverse().then((value) {
        popAnimController.forward();
      });
    }
    showAnimController.addListener(() {
      setState(() {});
    });
    popAnimController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    showAnimController.dispose();
    popAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpandableTextfield(
                  maxLines: 8,
                  minLines: 1,
                  maxCharacters: widget.maxCharacters,
                  onChanged: (value) {
                    setState(() {
                      commentLength = value.length;
                    });
                    manageAnim();
                  },
                  controller: commentController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AnimatedSize(
                    clipBehavior: Clip.none,
                    duration: const Duration(milliseconds: 200),
                    child: commentController.text.isEmpty
                        ? Container()
                        : Opacity(
                            opacity: popAnim.value,
                            child: Opacity(
                              opacity: showAnim.value == 0.0 ? 1.0 : 0.0,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 15, top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SimpleTextButton(
                                        tooltipLocation: TooltipLocation.above,
                                        text: 'delete',
                                        tooltip: 'delete your comment',
                                        isErrorText: true,
                                        onTap: () {
                                          // Clears text.
                                          commentController.clear();
                                          // Pushes down oard (unfocus).
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                      const SizedBox(width: 15),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextLimitTracker(
                                          noText: true,
                                          value: commentLength /
                                              widget.maxCharacters,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Spacer(),
                                      SimpleTextButton(
                                        tapType: TapType.strongImpact,
                                        tooltipLocation: TooltipLocation.above,
                                        text: 'post',
                                        tooltip: 'submit comment to thread',
                                        onTap: () {
                                          // Pushes down keyboard (unfocus).
                                          FocusScope.of(context).unfocus();
                                          // Pseudo 'Submits' the comment.
                                          widget
                                              .onSubmit(commentController.text);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
