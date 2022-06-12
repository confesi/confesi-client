import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/explore/explore_post.dart';
import 'package:flutter_mobile_client/widgets/buttons/comment.dart';
import 'package:flutter_mobile_client/widgets/buttons/option.dart';
import 'package:flutter_mobile_client/widgets/buttons/reaction.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/scrollbar.dart';
import 'package:flutter_mobile_client/widgets/sheets/button.dart';
import 'package:flutter_mobile_client/widgets/symbols/circle.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PostTile extends StatelessWidget {
  const PostTile(
      {required this.date,
      required this.icon,
      required this.faculty,
      required this.genre,
      required this.body,
      required this.likes,
      required this.dislikes,
      required this.comments,
      this.topLine = false,
      Key? key})
      : super(key: key);

  final IconData icon;
  final bool topLine;
  final String date;
  final String faculty;
  final String genre;
  final String body;
  final int likes;
  final int dislikes;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TouchableOpacity(
        onLongTap: () => showButtonSheet(context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExplorePost(),
          ),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      CircleSymbol(
                        radius: 25,
                        icon: icon,
                      ),
                      Expanded(
                        child: GroupText(
                          leftAlign: true,
                          body: "$date ∙ $faculty",
                          header: genre,
                          small: true,
                        ),
                      ),
                      TouchableOpacity(
                        onLongTap: () => showButtonSheet(context),
                        onTap: () => showButtonSheet(context),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 40),
                            // transparent hitbox trick
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 7),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  CupertinoIcons.ellipsis_vertical,
                                  color: Theme.of(context).colorScheme.onBackground,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    body,
                    style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        ReactionButton(
                          icon: CupertinoIcons.hand_thumbsup_fill,
                          count: likes,
                        ),
                        ReactionButton(
                          icon: CupertinoIcons.hand_thumbsdown_fill,
                          count: dislikes,
                        ),
                        CommentButton(count: comments),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
