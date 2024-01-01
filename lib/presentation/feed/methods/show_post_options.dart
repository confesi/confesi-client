import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/core/services/primary_tab_service/primary_tab_service.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../init.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';

// Show the options for this post.
void buildOptionsSheet(BuildContext context, PostWithMetadata post, {bool showSaved = true}) {
  // Obtain necessary dependencies up front
  final postsService = Provider.of<PostsService>(context, listen: false);
  final globalContentService = Provider.of<GlobalContentService>(context, listen: false);
  final notificationsCubit = context.read<NotificationsCubit>();
  final quickActionsCubit = context.read<QuickActionsCubit>();

  showButtonOptionsSheet(context, [
    if (post.post.chatPost && !post.owner)
      OptionButton(
        bottomPadding: true,
        borderColor: Theme.of(context).colorScheme.secondary,
        text: "Open anonymous DM",
        primaryColor: Theme.of(context).colorScheme.secondary,
        icon: CupertinoIcons.chat_bubble_2_fill,
        onTap: () async => verifiedUserOnly(
          context,
          () async => (await Provider.of<RoomsService>(context, listen: false).createNewRoom(post.post.id.mid)).fold(
            (_) => router.push("/home/rooms"),
            (errMsg) => context.read<NotificationsCubit>().showErr(errMsg),
          ),
        ),
      ),
    if (post.owner)
      OptionButton(
        isRed: true,
        text: "Delete",
        icon: CupertinoIcons.trash,
        onTap: () => postsService.deletePost(post).then(
              (either) => either.fold(
                (_) => null, // do nothing on success
                (errMsg) => notificationsCubit.showErr(errMsg),
              ),
            ),
      ),
    if (showSaved)
      OptionButton(
        text: post.saved ? "Unsave" : "Save",
        icon: post.saved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
        onTap: () => verifiedUserOnly(
            context,
            () async => await globalContentService.updatePostSaved(post.post.id, !post.saved).then(
                  (value) => value.fold(
                    (_) => null,
                    (err) => notificationsCubit.showErr(err),
                  ),
                )),
      ),
    OptionButton(
      text: "Share",
      icon: CupertinoIcons.share,
      onTap: () => quickActionsCubit.sharePost(context, post),
    ),
    if (post.owner)
      OptionButton(
        text: "Edit",
        icon: CupertinoIcons.pencil,
        onTap: () => router.push("/create", extra: EditedPost(post.post.title, post.post.content, post.post.id)),
      ),
    OptionButton(
      text: "Sentiment analysis",
      icon: CupertinoIcons.doc_text,
      onTap: () => router.push(
        "/home/posts/sentiment",
        extra: HomePostsSentimentProps(post.post.id),
      ),
    ),
    OptionButton(
      text: "School location",
      icon: CupertinoIcons.map,
      onTap: () => quickActionsCubit.locateOnMaps(
          post.post.school.lat.toDouble(), post.post.school.lon.toDouble(), post.post.school.name),
    ),
    if (!post.reported)
      OptionButton(
        text: "Report",
        icon: CupertinoIcons.flag,
        onTap: () => print("tap"),
      ),
    if (post.reported)
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          "Content already reported. We're reviewing it now. Thank you. 🙏",
          style: kDetail.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      )
  ]);
}
