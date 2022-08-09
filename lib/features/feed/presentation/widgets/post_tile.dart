import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:Confessi/core/widgets/sheets/button_options.dart';
import 'package:Confessi/core/widgets/text/group.dart';
import 'package:Confessi/features/feed/constants.dart';
import 'package:Confessi/features/feed/presentation/widgets/quote_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postView == PostView.feedView
          ? Navigator.pushNamed(
              context,
              '/home/detail',
              arguments: {
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
                  onTap: () => showButtonOptionsSheet(context),
                  child: Container(
                    // Transparent container hitbox trick.
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.ellipsis,
                        color: Theme.of(context).colorScheme.onSurface,
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
            QuoteTile(
              genre: 'Relationships',
              postView: postView,
              text:
                  'I cannot believe my boyfriend sometimes! Oh my goodness, he is so annoying. Seriously. This really makes me angry. I am trying to be melodramatic right now! Take me seriously!',
            ),
            //! Bottom row
            Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                VoteTileSet(
                  isLarge: false,
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
