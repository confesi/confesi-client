import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The type of sort that the comment section is doing.
enum CommentSortType {
  best,
  recent,
  liked,
  hated,
}

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
  });

  final Function(CommentSortType) onSwitch;

  @override
  State<SimpleCommentSort> createState() => _SimpleCommentSortState();
}

class _SimpleCommentSortState extends State<SimpleCommentSort> {
  String commentSortTypeToString(CommentSortType commentSortType) {
    switch (commentSortType) {
      case CommentSortType.best:
        return "best";
      case CommentSortType.recent:
        return "recent";
      case CommentSortType.liked:
        return "liked";
      case CommentSortType.hated:
        return "hated";
    }
  }

  void updateCommentType(CommentSortType newCommentSortType) {
    setState(() {
      commentSortType = newCommentSortType;
    });
    widget.onSwitch(commentSortType);
  }

  CommentSortType commentSortType = CommentSortType.best;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.8,
          ),
        ),
      ),
      child: TouchableOpacity(
        onTap: () => showButtonOptionsSheet(
          context,
          [
            OptionButton(
              onTap: () => updateCommentType(CommentSortType.best),
              text: "Best (recommended)",
              icon: CupertinoIcons.flame,
            ),
            OptionButton(
              onTap: () => updateCommentType(CommentSortType.recent),
              text: "Recent",
              icon: CupertinoIcons.clock,
            ),
            OptionButton(
              onTap: () => updateCommentType(CommentSortType.liked),
              text: "Liked",
              icon: CupertinoIcons.arrow_up,
            ),
            OptionButton(
              onTap: () => updateCommentType(CommentSortType.hated),
              text: "Hated",
              icon: CupertinoIcons.arrow_down,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Sorting comments by: ${commentSortTypeToString(commentSortType)}",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                CupertinoIcons.slider_horizontal_3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}