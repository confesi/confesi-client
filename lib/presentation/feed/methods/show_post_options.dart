import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/shared/cubit/maps_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';

// Show the options for this post.
void buildOptionsSheet(BuildContext context) => showButtonOptionsSheet(context, [
      OptionButton(
        text: "Save",
        icon: CupertinoIcons.bookmark,
        onTap: () => print("tap"),
      ),
      OptionButton(
        text: "Sentiment analysis",
        icon: CupertinoIcons.doc_text,
        onTap: () => router.push(
          "/home/posts/sentiment",
          extra: const HomePostsSentimentProps(1),
        ), // todo: remove hard coding and dynamically go to the correct post's sentiment analysis
      ),
      OptionButton(
        text: "School location",
        icon: CupertinoIcons.map,
        onTap: () =>
            context.read<MapsCubit>().launchMapAtLocation(48.4634, -123.3117, "UVIC"), // todo: remove hard coding
      ),
      OptionButton(
        text: "Report",
        icon: CupertinoIcons.flag,
        onTap: () => print("tap"),
      ),
    ]);
