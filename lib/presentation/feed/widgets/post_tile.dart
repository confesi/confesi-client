import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/text/group.dart';
import 'package:Confessi/core/constants/feed/constants.dart';
import 'package:Confessi/domain/shared/entities/badge.dart';
import 'package:Confessi/domain/feed/entities/post_child.dart';
import 'package:Confessi/presentation/feed/widgets/badge_tile.dart';
import 'package:Confessi/presentation/feed/widgets/badge_tile_set.dart';
import 'package:Confessi/presentation/feed/widgets/quote_tile.dart';
import 'package:Confessi/presentation/feed/widgets/vote_tile_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/shared/feed.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    required this.genre,
    required this.time,
    required this.faculty,
    required this.text,
    required this.title,
    required this.likes,
    required this.hates,
    required this.comments,
    required this.year,
    required this.university,
    required this.icon,
    this.postView = PostView.feedView,
    required this.postChild,
    required this.badges,
    required this.universityFullName,
    required this.id,

    Key? key,
  }) : super(key: key);


  final String? id;
  final String universityFullName;
  final IconData icon;
  final String university;
  final String genre;
  final String time;
  final String faculty;
  final String text;
  final String title;
  final int likes;
  final int hates;
  final int year;
  final int comments;
  final PostView postView;
  final PostChild postChild;
  final List<Badge> badges;

  Widget _renderQuoteChild(BuildContext context) {
    final ChildType childType = postChild.childType;
    if (childType == ChildType.noChild) {
      return Container();
    } else if (childType == ChildType.childNeedsLoading) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: 0.7,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        child: const CupertinoActivityIndicator(radius: 12),
      );
    } else {
      return QuoteTile(
        post: postChild.childPost!,
        postView: postView,
      );
    }
  }

  List<BadgeTile> getBadges() => badges
      .map((badge) => BadgeTile(text: badge.text, icon: badge.icon))
      .toList();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postView == PostView.feedView
          ? Navigator.pushNamed(
              context,
              '/home/detail',
              arguments: {
                'id': id,
                'badges': badges,
                'post_child': postChild,
                'icon': icon,
                'genre': genre,
                'time': time,
                'faculty': faculty,
                'text': text,
                'title': title,
                'likes': likes,
                'hates': hates,
                'comments': comments,
                'year': year,
                'university': university,
                'university_full_name': universityFullName,
                'postView': PostView.detailView
              },
            )
          : FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //! Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GroupText(
                    body: "$time / year $year / $faculty",
                    header: genre,
                    leftAlign: true,
                    small: true,
                  ),
                ),
                TouchableOpacity(
                  tooltip: 'post options',
                  tooltipLocation: TooltipLocation.above,
                  onTap: () {
                    showButtonOptionsSheet(context, [
                      OptionButton(
                        text: "Report",
                        icon: CupertinoIcons.flag,
                        onTap: () => print("tap"),
                      ),
                      OptionButton(
                        text: "Share",
                        icon: CupertinoIcons.share,
                        onTap: () => print("tap"),
                      ),
                      OptionButton(
                        text: "Quote",
                        icon: CupertinoIcons.paperplane,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/home/create_replied_post',
                          arguments: {
                            'title': title,
                            'body': text,
                            'id': id,
                          },
                        ),
                      ),
                      OptionButton(
                        text: "Save",
                        icon: CupertinoIcons.bookmark,
                        onTap: () => print("tap"),
                      ),
                      OptionButton(
                        text: "Details",
                        icon: CupertinoIcons.info,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/home/post/stats',
                          arguments: {
                            'comments': comments,
                            'faculty': faculty,
                            'genre': genre,
                            'hates': hates,
                            'likes': likes,
                            // TODO: implement 'moderation_status' and 'saves'
                            'moderation_status': 'IMPLEMENT THIS STILL',
                            'saves': 999999,
                            'university': university,
                            'year': year,
                            'university_full_name': universityFullName,
                          },
                        ),
                      ),
                    ]);
                  },
                  child: Container(
                    // Transparent container hitbox trick.
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.ellipsis,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: title.isEmpty ? 15 : 30),
            //! Title row
            Text(
              title.length > kPreviewPostTitleLength &&
                      postView == PostView.feedView
                  ? "${title.substring(0, kPreviewPostTitleLength)}..."
                  : title,
              style: kTitle.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title.isEmpty || getBadges().isEmpty
                ? Container()
                : const SizedBox(height: 2),
            BadgeTileSet(
              badges: getBadges(),
            ),
            SizedBox(height: title.isEmpty ? 15 : 30),
            //! Middle row
            Text(
              text.length > kPreviewPostTextLength &&
                      postView == PostView.feedView
                  ? "${text.substring(0, kPreviewPostTextLength)}..."
                  : text,
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.primary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 30),
            _renderQuoteChild(context),
            //! Bottom row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VoteTileSet(
                  likes: likes,
                  hates: hates,
                ),
                postView == PostView.feedView
                    ? Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            isPlural(comments) == true
                                ? "$comments comments"
                                : "$comments comment",
                            style: kDetail.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
