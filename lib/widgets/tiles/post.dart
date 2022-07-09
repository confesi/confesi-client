import 'package:Confessi/models/feed/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../constants/general.dart';
import '../../constants/typography.dart';
import '../../screens/explore/explore_post.dart';
import '../buttons/post.dart';
import '../buttons/touchable_opacity.dart';
import '../sheets/button.dart';
import '../symbols/circle.dart';
import '../text/group.dart';
import 'post_reply.dart';

class PostTile extends StatelessWidget {
  const PostTile(
      {required this.date,
      required this.icon,
      required this.faculty,
      required this.genre,
      required this.text,
      required this.comments,
      required this.votes,
      required this.year,
      required this.replyingtoPost,
      this.threadView = false,
      Key? key})
      : super(key: key);

  final String? replyingtoPost;
  final IconData icon;
  final bool threadView;
  final String date;
  final String faculty;
  final String genre;
  final String text;
  final int year;
  final int votes;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        // onTap: () => threadView
        //     ? null
        //     : Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ExplorePost(
        //               parentFaculty: parentFaculty,
        //               parentGenre: parentGenre,
        //               parentText: parentText,
        //               parentID: parentID,
        //               date: date,
        //               icon: icon,
        //               faculty: faculty,
        //               genre: genre,
        //               body: body,
        //               likes: likes,
        //               votes: dislikes,
        //               comments: comments),
        //         ),
        //       ),
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          body: "$date ∙ $faculty ∙ year $year",
                          header: "$genre $replyingtoPost",
                          small: true,
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: TouchableOpacity(
                          onTap: () => showButtonSheet(context),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 40),
                                // transparent hitbox trick
                                color: Colors.transparent,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    CupertinoIcons.ellipsis,
                                    color: Theme.of(context).colorScheme.onBackground,
                                    size: 24,
                                  ),
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
                    replyingtoPost != null
                        ? text
                        : "${text.substring(0, text.length >= kPostPreviewCharacters ? kPostPreviewCharacters : text.length)} ${text.length >= kPostPreviewCharacters && !threadView ? "..." : ""}",
                    style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        height: 1.4,
                        fontSize: replyingtoPost != null ? 19 : null),
                    textAlign: TextAlign.left,
                  ),
                ),
                threadView
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 15),
                              child: Text(
                                "reacting to:",
                                style:
                                    kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ),
                            PostReplyTile(
                              onPress: () => print("Going to: ${"ERROR"}"),
                              university: "error",
                              genre: "error",
                              body: "error",
                              threadView: threadView,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        PostButton(
                          onPress: () => print("yeet"),
                          icon: CupertinoIcons.hand_thumbsup,
                          value: votes,
                        ),
                        PostButton(
                          onPress: () => print("yeet"),
                          icon: CupertinoIcons.hand_thumbsdown,
                          value: votes,
                        ),
                        PostButton(
                          onPress: () => print("yeet"),
                          icon: CupertinoIcons.chat_bubble,
                          value: comments,
                        ),
                        PostButton(
                          onPress: () => print("yeet"),
                          icon: CupertinoIcons.share,
                          value: "share",
                        ),
                        PostButton(
                          onPress: () => print("yeet"),
                          icon: CupertinoIcons.arrow_2_squarepath,
                          value: "repost",
                        ),
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
