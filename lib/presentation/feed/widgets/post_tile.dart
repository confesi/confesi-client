import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
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
import '../methods/show_post_options.dart';
import '../utils/post_metadata_formatters.dart';

class PostTile extends StatefulWidget {
  final PostWithMetadata post;

  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  PostTileState createState() => PostTileState();
}

class PostTileState extends State<PostTile> {
  late final String truncatedTitle;
  late final int titleLastIndex;
  late final String truncatedContent;
  late final int bodyLastIndex;

  @override
  void initState() {
    super.initState();

    truncatedTitle = truncateText(
        widget.post.post.title.isEmpty ? widget.post.post.content : widget.post.post.title, postTitlePreviewLength);
    titleLastIndex = truncateTextLastIndex(
        widget.post.post.title.isEmpty ? widget.post.post.content : widget.post.post.title, postTitlePreviewLength);

    truncatedContent = truncateText(widget.post.post.content, postBodyPreviewLength);
    bodyLastIndex = truncateTextLastIndex(widget.post.post.content, postBodyPreviewLength);
  }

// Use the truncatedTitle and truncatedContent in your Text widgets.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => router.push("/home/posts/comments",
          extra: HomePostsCommentsProps(PreloadedPost(widget.post, false),
              titleLastChar: titleLastIndex, bodyLastChar: bodyLastIndex)),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            // top: BorderSide(
            //   color: Theme.of(context).colorScheme.onBackground,
            //   width: borderSize,
            //   style: BorderStyle.solid,
            // ),
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
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.post.post.school.name}${buildFaculty(widget.post)}${buildYear(widget.post)}",
                                      style: kDetail.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start, // adjust this as per your alignment preference
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center, // adjust this too as per your needs
                                      children: <Widget>[
                                        Text(
                                          "${timeAgoFromMicroSecondUnixTime(widget.post.post.createdAt)}${widget.post.emojis.isNotEmpty ? " • ${widget.post.emojis.map((e) => e).join("")}" : ""}",
                                          style: kDetail.copyWith(
                                            color: Theme.of(context).colorScheme.tertiary,
                                          ),
                                        ),
                                        if (widget.post.post.edited) ...[
                                          // using spread operator to conditionally render widgets
                                          const SizedBox(width: 5), // add some space between text widgets
                                          Text(
                                            "Edited",
                                            style: kDetail.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              TouchableOpacity(
                                onTap: () => buildOptionsSheet(context, widget.post, showSaved: false),
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
                          child: Text(
                            truncateText(
                                widget.post.post.title.isEmpty ? widget.post.post.content : widget.post.post.title,
                                postTitlePreviewLength),
                            style: kDisplay1.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: kDisplay1.fontSize! *
                                  Provider.of<UserAuthService>(context).data().textSize.multiplier,
                            ),
                          ),
                        ),
                        WidgetOrNothing(
                          showWidget: widget.post.post.title.isNotEmpty && widget.post.post.content.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Text(
                              truncateText(widget.post.post.content, postBodyPreviewLength),
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize:
                                    kBody.fontSize! * Provider.of<UserAuthService>(context).data().textSize.multiplier,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SizedBox(height: widget.post.post.imgUrls.isEmpty ? 15 : 0),
                        WidgetOrNothing(
                          showWidget: widget.post.post.imgUrls.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ImgViewer(
                              imgUrls: widget.post.post.imgUrls,
                              isBlurred: Provider.of<UserAuthService>(context, listen: true).data().blurImages,
                              heroAnimPrefix: "post_tile",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ReactionTile(
                                    simpleView: false,
                                    amount: widget.post.post.commentCount,
                                    icon: CupertinoIcons.chat_bubble,
                                    iconColor: Theme.of(context).colorScheme.tertiary,
                                    isSelected: true,
                                    onTap: () => verifiedUserOnly(
                                      context,
                                      () => router.push(
                                        "/home/posts/comments",
                                        extra: HomePostsCommentsProps(
                                          PreloadedPost(widget.post, true),
                                          titleLastChar: titleLastIndex,
                                          bodyLastChar: bodyLastIndex,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ReactionTile(
                                    onTap: () async => verifiedUserOnly(
                                        context,
                                        () async => await Provider.of<GlobalContentService>(context, listen: false)
                                            .updatePostSaved(widget.post.post.id, !widget.post.saved)
                                            .then(
                                              (value) => value.fold(
                                                (_) => null,
                                                (err) => context.read<NotificationsCubit>().showErr(err),
                                              ),
                                            )),
                                    icon: widget.post.saved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                                    iconColor: Theme.of(context).colorScheme.secondary,
                                    isSelected: widget.post.saved,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ReactionTile(
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
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ReactionTile(
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
                                ),
                              ],
                            ),
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
    );
  }
}
