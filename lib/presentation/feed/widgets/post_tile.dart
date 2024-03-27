import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/extensions/strings/new_lines.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/utils/strings/truncate_text.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/feed/widgets/img_viewer.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../../dms/utils/time_ago.dart';
import '../../shared/edited_source_widgets/text.dart';
import '../methods/show_post_options.dart';
import '../utils/post_metadata_formatters.dart';

class PostTile extends StatefulWidget {
  final PostWithMetadata post;

  const PostTile({Key? key, required this.post, this.detailView = false}) : super(key: key);

  final bool detailView;

  @override
  PostTileState createState() => PostTileState();
}

class PostTileState extends State<PostTile> {
  // Use the truncatedTitle and truncatedContent in your Text widgets.

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.detailView ? 15 : 15,
            left: widget.detailView ? 0 : 0,
            right: widget.detailView ? 0 : 0,
            bottom: widget.detailView ? 0 : 0),
        child: GestureDetector(
          onLongPress: () {
            Haptics.f(H.regular);
            buildOptionsSheet(context, widget.post);
          },
          onTap: () {
            if (widget.detailView) return;
            Haptics.f(H.regular);
            router.push(
              "/home/posts/comments",
              extra: HomePostsCommentsProps(
                PreloadedPost(widget.post, false),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: widget.detailView ? null : null,
              border: Border(
                top: widget.detailView
                    ? BorderSide.none
                    : BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: borderSize,
                        style: BorderStyle.solid,
                      ),
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: borderSize,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Stack(
                children: [
                  Visibility(
                    visible: Provider.of<UserAuthService>(context).data().categorySplashes,
                    child: Positioned(
                      bottom: -75,
                      right: -75,
                      child: Icon(
                        postCategoryToIcon(widget.post.post.category.category),
                        // color: Colors.transparent,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(1),
                        size: 250,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SafeText(
                                      "${widget.post.post.school.name}${buildFaculty(widget.post)}${buildYear(widget.post)} • ${timeAgo(DateTime.fromMicrosecondsSinceEpoch(widget.post.post.createdAt))} ${widget.post.post.edited ? "• Edited" : ""}",
                                      style: kDetail.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  TouchableOpacity(
                                    onTap: () {
                                      Haptics.f(H.regular);
                                      buildOptionsSheet(context, widget.post);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Icon(
                                        CupertinoIcons.ellipsis_circle,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                              child: SafeText(
                                truncateText(
                                    widget.post.post.title.isEmpty
                                        ? "[empty]"
                                        : widget.post.post.title.removeExtraNewLines,
                                    postTitlePreviewLength,
                                    truncating: !widget.detailView),
                                style: kDisplay1.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: kDisplay1.fontSize! *
                                      Provider.of<UserAuthService>(context).data().textSize.multiplier,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: SafeText(
                                truncateText(
                                    widget.post.post.content.isEmpty
                                        ? "[empty]"
                                        : widget.post.post.content.removeExtraNewLines,
                                    postBodyPreviewLength,
                                    truncating: !widget.detailView),
                                style: kBody.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: kBody.fontSize! *
                                      Provider.of<UserAuthService>(context).data().textSize.multiplier,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: widget.post.post.imgUrls.isEmpty ? 15 : 0),
                            WidgetOrNothing(
                              showWidget: widget.post.post.imgUrls.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: ImgViewer(
                                  imageSources: widget.post.post.imgUrls.map((e) => MyImageSource(url: e)).toList(),
                                  isBlurred: Provider.of<UserAuthService>(context, listen: true).data().blurImages,
                                  heroAnimPrefix: "post_tile",
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ReactionTile(
                                    simpleView: true,
                                    amount: widget.post.post.commentCount,
                                    icon: CupertinoIcons.chat_bubble_2_fill,
                                    iconColor: Theme.of(context).colorScheme.tertiary,
                                    isSelected: true,
                                    onTap: () {}, // Do nothing!
                                  ),
                                  // if chat post
                                  if (widget.post.post.chatPost && !widget.post.owner)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(
                                        CupertinoIcons.chat_bubble_2,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 16,
                                      ),
                                    ),
                                  if (widget.post.owner)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(
                                        CupertinoIcons.profile_circled,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 16,
                                      ),
                                    ),
                                  const Spacer(),
                                  ReactionTile(
                                    simpleView: true,
                                    onTap: () async => verifiedUserOnly(
                                        context,
                                        () async => await Provider.of<GlobalContentService>(context, listen: false)
                                            .voteOnPost(widget.post, widget.post.userVote != -1 ? -1 : 0)
                                            .then((value) => value.fold(
                                                (err) => context.read<NotificationsCubit>().showErr(err),
                                                (_) => null))),
                                    amount: widget.post.post.downvote,
                                    icon: CupertinoIcons.down_arrow,
                                    iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                    isSelected: widget.post.userVote == -1,
                                  ),
                                  const SizedBox(width: 15),
                                  ReactionTile(
                                    simpleView: true,
                                    onTap: () async => verifiedUserOnly(
                                      context,
                                      () async => await Provider.of<GlobalContentService>(context, listen: false)
                                          .voteOnPost(widget.post, widget.post.userVote != 1 ? 1 : 0)
                                          .then(
                                            (value) => value.fold(
                                                (err) => context.read<NotificationsCubit>().showErr(err), (_) => null),
                                          ),
                                    ),
                                    isSelected: widget.post.userVote == 1,
                                    amount: widget.post.post.upvote,
                                    icon: CupertinoIcons.up_arrow,
                                    iconColor: Theme.of(context).colorScheme.onErrorContainer,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
