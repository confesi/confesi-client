import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/widgets/textfields/thin.dart';

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
      // reverse other anim (hide it)
      popAnimController.reverse();
      showAnimController.forward();
    } else {
      showAnimController.reverse().then((value) {
        print('START');
        // start other anim (show it)
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThinTextfield(
            maxLines: 5,
            minLines: 1,
            maxCharacters: widget.maxCharacters,
            onChanged: (value) {
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
                            padding: const EdgeInsets.only(bottom: 15, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'writing to #general',
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: kBody.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TouchableOpacity(
                                  tooltip: 'submit comment to thread',
                                  onTap: () =>
                                      widget.onSubmit(commentController.text),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'post comment',
                                      textAlign: TextAlign.right,
                                      style: kBody.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
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
    );
  }
}
