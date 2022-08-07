import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';

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

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController commentController = TextEditingController();

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
              setState(() {});
            },
            controller: commentController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AnimatedSize(
              clipBehavior: Clip.none,
              duration: const Duration(milliseconds: 100),
              child: commentController.text.isEmpty
                  ? Container()
                  : Align(
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TouchableOpacity(
                              onTap: () =>
                                  widget.onSubmit(commentController.text),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'post comment',
                                  textAlign: TextAlign.right,
                                  style: kBody.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
        ],
      ),
    );
  }
}
