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
    return TouchableOpacity(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExplorePost(),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: topLine ? Theme.of(context).colorScheme.surface : Colors.transparent,
                width: topLine ? 1 : 0),
            bottom: BorderSide(color: Theme.of(context).colorScheme.surface, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
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
                    onTap: () => showButtonSheet(context),
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
                body,
                style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              Align(
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
            ],
          ),
        ),
      ),
    );
  }
}
