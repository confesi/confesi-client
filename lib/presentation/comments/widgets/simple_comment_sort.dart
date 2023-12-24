import 'package:confesi/constants/shared/constants.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The type of sort that the comment section is doing.
enum CommentSortType { trending, recent }

// method on enum to convert it to exactly its name in string form
extension CommentSortTypeExtension on CommentSortType {
  String name() {
    if (this == CommentSortType.recent) return "new";
    return toString().split('.').last.toLowerCase();
  }
}

class SimpleCommentSort extends StatefulWidget {
  const SimpleCommentSort({
    super.key,
    required this.onSwitch,
    required this.commentSortType,
  });

  final Function(CommentSortType) onSwitch;
  final CommentSortType commentSortType;

  @override
  State<SimpleCommentSort> createState() => _SimpleCommentSortState();
}

class _SimpleCommentSortState extends State<SimpleCommentSort> {
  String commentSortTypeToString(CommentSortType commentSortType) {
    switch (commentSortType) {
      case CommentSortType.trending:
        return "trending";
      case CommentSortType.recent:
        return "recent";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => showButtonOptionsSheet(
        context,
        [
          OptionButton(
            onTap: () => widget.onSwitch(CommentSortType.trending),
            text: "Trending",
            icon: CupertinoIcons.flame,
          ),
          OptionButton(
            onTap: () => widget.onSwitch(CommentSortType.recent),
            text: "Recent",
            icon: CupertinoIcons.clock,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        color: Colors.transparent, // hitbox trick
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Icon(
                CupertinoIcons.chat_bubble_2,
                color: Theme.of(context).colorScheme.onSurface,
                size: 18,
              ),
            ),
            const SizedBox(width: 5),
            RichText(
              text: TextSpan(
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: "Sorting comments by ",
                    style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  TextSpan(
                    text: commentSortTypeToString(widget.commentSortType),
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
