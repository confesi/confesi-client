import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/explore/explore_post.dart';
import 'package:flutter_mobile_client/widgets/buttons/comment.dart';
import 'package:flutter_mobile_client/widgets/buttons/info.dart';
import 'package:flutter_mobile_client/widgets/buttons/option.dart';
import 'package:flutter_mobile_client/widgets/buttons/post.dart';
import 'package:flutter_mobile_client/widgets/buttons/reaction.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/scrollbar.dart';
import 'package:flutter_mobile_client/widgets/sheets/button.dart';
import 'package:flutter_mobile_client/widgets/symbols/circle.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/tiles/post_reply.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../constants/general.dart';

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
      this.threadView = false,
      this.parentID,
      this.parentText,
      this.parentGenre,
      this.parentFaculty,
      Key? key})
      : super(key: key);

  final ObjectId? parentID;
  final String? parentText;
  final String? parentGenre;
  final String? parentFaculty;
  final bool threadView;
  final IconData icon;
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
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => threadView
            ? null
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExplorePost(
                      parentFaculty: parentFaculty,
                      parentGenre: parentGenre,
                      parentText: parentText,
                      parentID: parentID,
                      date: date,
                      icon: icon,
                      faculty: faculty,
                      genre: genre,
                      body: body,
                      likes: likes,
                      dislikes: dislikes,
                      comments: comments),
                ),
              ),
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
                          body: "$date ∙ $faculty",
                          header: genre,
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
                    threadView
                        ? body
                        : "${body.substring(0, body.length >= kPostPreviewCharacters ? kPostPreviewCharacters : body.length)} ${body.length >= kPostPreviewCharacters && !threadView ? "..." : ""}",
                    style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        height: 1.4,
                        fontSize: threadView ? 19 : null),
                    textAlign: TextAlign.left,
                  ),
                ),
                parentID != null
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
                              onPress: () => print("Going to: ${parentID ?? "ERROR"}"),
                              university: parentFaculty ?? "error",
                              genre: parentGenre ?? "error",
                              body: parentText ?? "error",
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
                          value: likes,
                        ),
                        PostButton(
                          onPress: () => print("yeet"),
                          icon: CupertinoIcons.hand_thumbsdown,
                          value: dislikes,
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
