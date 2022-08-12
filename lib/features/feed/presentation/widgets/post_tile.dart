import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:Confessi/core/widgets/text/group.dart';
import 'package:Confessi/features/feed/constants.dart';
import 'package:Confessi/features/feed/domain/entities/post_child.dart';
import 'package:Confessi/core/widgets/sheets/button_options_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/quote_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/buttons/option.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    required this.genre,
    required this.time,
    required this.faculty,
    required this.text,
    required this.votes,
    required this.comments,
    required this.year,
    required this.university,
    required this.icon,
    this.postView = PostView.feedView,
    required this.postChild,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String university;
  final String genre;
  final String time;
  final String faculty;
  final String text;
  final int votes;
  final int year;
  final String comments;
  final PostView postView;
  final PostChild postChild;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postView == PostView.feedView
          ? Navigator.pushNamed(
              context,
              '/home/detail',
              arguments: {
                'post_child': postChild,
                'icon': icon,
                'genre': genre,
                'time': time,
                'faculty': faculty,
                'text': text,
                'votes': votes,
                'comments': comments,
                'year': year,
                'university': university,
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
                  onTap: () => showButtonOptionsSheet(context, [
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
                      text: "Reply",
                      icon: CupertinoIcons.paperplane,
                      onTap: () => print("tap"),
                    ),
                    OptionButton(
                      text: "Save",
                      icon: CupertinoIcons.bookmark,
                      onTap: () => print("tap"),
                    ),
                    OptionButton(
                      text: "Details",
                      icon: CupertinoIcons.info,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home/post/stats');
                      },
                    ),
                  ]),
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
            const SizedBox(height: 30),
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
            // Text('For Debugging: ${postChild.childType.toString()}'),
            //! Bottom row
            Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                VoteTileSet(
                  votes: votes,
                ),
                Text(
                  comments,
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
