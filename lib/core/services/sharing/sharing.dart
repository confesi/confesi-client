import 'dart:io';

import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/utils/dates/readable_date_format.dart';
import 'package:confesi/core/utils/strings/truncate_text.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:flutter/cupertino.dart';

import '../../../presentation/profile/screens/account_stats.dart';
import '../../../presentation/profile/widgets/stat_tile.dart';
import '../../../presentation/shared/selection_groups/text_stat_tile.dart';
import '../../../presentation/shared/selection_groups/tile_group.dart';
import '../../styles/themes.dart';
import '../../styles/typography.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../results/failures.dart';
import '../../results/successes.dart';

class Sharing {
  Future<Either<Failure, Success>> sharePost(BuildContext context, PostWithMetadata post) async {
    // todo: generate link using FCM based on post's id
    try {
      File file = await _screenshotPost(context, post);
      Share.shareXFiles([XFile(file.path)],
          text: "🚀 Check out this confession! https://confesi.com/p/${post.post.id.mid}",
          subject: "Confesi"); // todo: make dynamic
      return Right(ApiSuccess());
    } catch (_) {
      return Left(ShareFailure());
    }
  }

  Future<Either<Failure, Success>> shareStats(BuildContext context, int likes, int hottests, int dislikes,
      num likesPerc, num hottestPerc, num dislikesPerc) async {
    try {
      File file = await _screenshotStats(context, likes, hottests, dislikes, likesPerc, hottestPerc, dislikesPerc);
      Share.shareXFiles([XFile(file.path)], text: "🎉 Check out my Confesi stats!", subject: "Confesi");
      return Right(ApiSuccess());
    } catch (_) {
      return Left(ShareFailure());
    }
  }

  Future<File> _screenshotStats(BuildContext context, int likes, int hottests, int dislikes, num likesPerc,
      num hottestPerc, num dislikesPerc) async {
    final capturedImage = await ScreenshotController().captureFromWidget(
        _buildStatsTile(context, likes, hottests, dislikes, likesPerc, hottestPerc, dislikesPerc),
        delay: const Duration(milliseconds: 10));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/confession.png');
    return await file.writeAsBytes(capturedImage);
  }

  Future<File> _screenshotPost(BuildContext context, PostWithMetadata post) async {
    final capturedImage = await ScreenshotController()
        .captureFromWidget(_buildPost(context, post), delay: const Duration(milliseconds: 10));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/confession.png');
    return await file.writeAsBytes(capturedImage);
  }

  String timeAgoFromMicroSecondUnixTime(PostWithMetadata post) {
    var timeAgo = DateTime.fromMicrosecondsSinceEpoch(post.post.createdAt);
    return timeAgo.xTimeAgoLocalDateFormat();
  }

  Widget _buildStatsTile(
      BuildContext context, int likes, int hottests, int dislikes, num likesPerc, num hottestPerc, num dislikesPerc) {
    return Theme(
      data: AppTheme.dark,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(
          width: 400,
          color: Theme.of(context).colorScheme.shadow,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Account Statistics",
                        style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 15),
                      StatTile(
                        isSharing: true,
                        leftNumber: likes,
                        leftDescription: "Likes",
                        centerNumber: hottests,
                        centerDescription: "Hottests",
                        rightNumber: dislikes,
                        rightDescription: "Dislikes",
                      ),
                      TextStatTile(
                        isSharing: true,
                        leftText: "Likes 🎉",
                        rightText: percentToRelativeMsg(likesPerc),
                      ),
                      TextStatTile(
                        isSharing: true,
                        leftText: "Hottests 🔥",
                        rightText: percentToRelativeMsg(hottestPerc),
                      ),
                      TextStatTile(
                        isSharing: true,
                        leftText: "Dislikes 🤮",
                        rightText: percentToRelativeMsg(dislikesPerc),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 0.8,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            shape: BoxShape.circle),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            walrusHeadImgPath,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Confesi.com",
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context, PostWithMetadata post) {
    return Theme(
      data: AppTheme.dark, // always share in dark mode
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(
          width: 400,
          color: Theme.of(context).colorScheme.tertiary,
          child: Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 15),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.8,
                        strokeAlign: BorderSide.strokeAlignInside),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.7),
                        blurRadius: 50,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              post.post.school.name,
                              style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              timeAgoFromMicroSecondUnixTime(post),
                              style: kDetail.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          truncateText(post.post.title, kPostTitleMaxLength),
                          style: kDisplay1.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        truncateText(post.post.content, kPostBodyMaxLength),
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          ReactionTile(
                            simpleView: true,
                            amount: 1232, // todo: comment count
                            icon: CupertinoIcons.chat_bubble,
                            iconColor: Theme.of(context).colorScheme.tertiary,
                            isSelected: true,
                          ),
                          ReactionTile(
                            simpleView: true,
                            amount: post.post.upvote,
                            icon: CupertinoIcons.up_arrow,
                            iconColor: Theme.of(context).colorScheme.onErrorContainer,
                            isSelected: true,
                          ),
                          ReactionTile(
                            simpleView: true,
                            amount: post.post.downvote,
                            icon: CupertinoIcons.down_arrow,
                            iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            isSelected: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 0.8,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            shape: BoxShape.circle),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            walrusHeadImgPath,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Confesi.com",
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
