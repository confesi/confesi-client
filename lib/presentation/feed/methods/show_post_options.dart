import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';

// Show the options for this post.
void buildOptionsSheet(BuildContext context, PostWithMetadata post) => showButtonOptionsSheet(context, [
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
      OptionButton(
        text: "Save",
        icon: CupertinoIcons.bookmark,
        onTap: () => print("tap"),
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
        ), // todo: remove hard coding and dynamically go to the correct post's sentiment analysis
      ),
      OptionButton(
        text: "School location",
        icon: CupertinoIcons.map,
        onTap: () => context
            .read<QuickActionsCubit>()
            .locateOnMaps(post.post.school.lat.toDouble(), post.post.school.lon.toDouble(), post.post.school.name),
      ),
      OptionButton(
        text: "Report",
        icon: CupertinoIcons.flag,
        onTap: () => print("tap"),
      ),
    ]);
