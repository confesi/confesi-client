import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/utils/strings/truncate_text.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../methods/show_post_options.dart';
import '../utils/post_metadata_formatters.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => router.push("/home/posts/comments", extra: HomePostsCommentsProps(post, false)),
      onLongPress: () => context.read<QuickActionsCubit>().sharePost(context, post),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: Theme.of(context).colorScheme.onBackground,
              width: 0.8,
              style: BorderStyle.solid,
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Stack(
              children: [
                Positioned(
                  bottom: -30,
                  right: -30,
                  child: Icon(
                    postCategoryToIcon(post.category.category),
                    color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                    size: 150,
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
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  width: 0.8,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${post.school.name}${buildFaculty(post)}${buildYear(post)}",
                                        style: kDetail.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        "${timeAgoFromMicroSecondUnixTime(post.createdAt)} • ${post.emojis.map((e) => e).join(" ")}",
                                        style: kDetail.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                TouchableOpacity(
                                  onTap: () => buildOptionsSheet(context, post),
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
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                            child: Text(
                              truncateText(post.title, postTitlePreviewLength),
                              style: kDisplay1.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              truncateText(post.content, postBodyPreviewLength),
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          WidgetOrNothing(
                            showWidget: post.edited,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
                              child: Text(
                                "Edited",
                                style: kDetail.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                ReactionTile(
                                  simpleView: false,
                                  amount: post.commentCount,
                                  icon: CupertinoIcons.chat_bubble,
                                  iconColor: Theme.of(context).colorScheme.tertiary,
                                  isSelected: true,
                                  onTap: () =>
                                      router.push("/home/posts/comments", extra: HomePostsCommentsProps(post, true)),
                                ),
                                ReactionTile(
                                  onTap: () async => await Provider.of<GlobalContentService>(context, listen: false)
                                      .voteOnPost(post, post.userVote != 1 ? 1 : 0)
                                      .then((value) => value.fold(
                                          (err) => context.read<NotificationsCubit>().show(err), (_) => null)),
                                  isSelected: post.userVote == 1,
                                  amount: post.upvote,
                                  icon: CupertinoIcons.up_arrow,
                                  iconColor: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                ReactionTile(
                                  onTap: () async => await Provider.of<GlobalContentService>(context, listen: false)
                                      .voteOnPost(post, post.userVote != -1 ? -1 : 0)
                                      .then((value) => value.fold(
                                          (err) => context.read<NotificationsCubit>().show(err), (_) => null)),
                                  amount: post.downvote,
                                  icon: CupertinoIcons.down_arrow,
                                  iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                  isSelected: post.userVote == -1,
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
    );
  }
}
