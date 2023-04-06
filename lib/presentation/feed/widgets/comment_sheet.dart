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

class _CommentSheetState extends State<CommentSheet> with TickerProviderStateMixin {
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
    showAnim = CurvedAnimation(parent: showAnimController, curve: Curves.linear);
    popAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    popAnim = CurvedAnimation(parent: popAnimController, curve: Curves.linear);
    super.initState();
  }

  void manageAnim() {
    if (commentController.text.isEmpty) {
      popAnimController.reverse();
      showAnimController.forward();
    } else {
      showAnimController.reverse();
      popAnimController.forward();
    }
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpandableTextfield(
            hintText: "What's your take?",
            maxLines: 4,
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
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SimpleTextButton(
                  tooltipLocation: TooltipLocation.above,
                  text: 'Cancel really long text',
                  isErrorText: true,
                  onTap: () {
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
                Expanded(
                  child: TextLimitTracker(
                    noText: false,
                    value: commentLength / widget.maxCharacters,
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
        ],
      ),
    );
  }
}
