import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';

// Show the options for this post.
void buildOptionsSheet(BuildContext context, PostWithMetadata post, {bool showSaved = true}) =>
    showButtonOptionsSheet(context, [
      if (post.owner)
        OptionButton(
          isRed: true,
          text: "Delete",
          icon: CupertinoIcons.trash,
          onTap: () => Provider.of<PostsService>(context, listen: false).deletePost(post).then(
                (either) => either.fold(
                  (_) => null, // do nothing on success
                  (errMsg) => context.read<NotificationsCubit>().showErr(errMsg),
                ),
              ),
        ),
      if (showSaved)
        OptionButton(
          text: post.saved ? "Unsave" : "Save",
          icon: post.saved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
          onTap: () => verifiedUserOnly(
              context,
              () =>
                  Provider.of<GlobalContentService>(context, listen: false).updatePostSaved(post.post.id, !post.saved)),
        ),
      OptionButton(
        text: "Share",
        icon: CupertinoIcons.share,
        onTap: () => context.read<QuickActionsCubit>().sharePost(context, post),
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
        onTap: () => context
            .read<QuickActionsCubit>()
            .locateOnMaps(post.post.school.lat.toDouble(), post.post.school.lon.toDouble(), post.post.school.name),
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
