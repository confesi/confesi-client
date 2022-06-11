import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/comment.dart';
import 'package:flutter_mobile_client/widgets/buttons/reaction.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';
import 'package:flutter_mobile_client/widgets/symbols/circle.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';

class PostTile extends StatelessWidget {
  const PostTile({this.topLine = false, Key? key}) : super(key: key);

  final bool topLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: topLine ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
              width: topLine ? 1 : 0),
          bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                const CircleSymbol(radius: 25),
                const Expanded(
                  child: GroupText(
                    leftAlign: true,
                    body: "Dec 14, 9:04am ∙ engineering",
                    header: "Political",
                    small: true,
                  ),
                ),
                TouchableOpacity(
                  onTap: () => print("TOUCHABLE OPACITY TAPPED"),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 40),
                      // transparent hitbox trick
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CupertinoIcons.ellipsis_vertical,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Gotta be honest. Sometimes I swipe by girls and guys on Tinder or Bumble and I wish there was a super dislike button. Like bro, I don't know what your parents were thinking having you.",
              style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: const [
                  ReactionButton(
                    icon: CupertinoIcons.hand_thumbsup_fill,
                    count: 18,
                  ),
                  ReactionButton(
                    icon: CupertinoIcons.hand_thumbsdown_fill,
                    count: 6,
                  ),
                  CommentButton(count: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
