import 'package:flutter/material.dart';
import '../../constants/general.dart';
import '../../constants/typography.dart';
import '../buttons/touchable_opacity.dart';

class PostReplyTile extends StatelessWidget {
  const PostReplyTile(
      {required this.university,
      required this.genre,
      required this.body,
      required this.threadView,
      required this.onPress,
      Key? key})
      : super(key: key);

  final bool threadView;
  final String body;
  final String university;
  final String genre;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onPress(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.35,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$university ∙ $genre",
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                threadView
                    ? body
                    : "${body.substring(0, body.length >= kReplyingToPostPreviewCharacters ? kReplyingToPostPreviewCharacters : body.length)} ${body.length >= kReplyingToPostPreviewCharacters && !threadView ? "..." : ""}",
                style: kBody.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.4,
                    fontSize: threadView ? 19 : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
