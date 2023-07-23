import 'dart:convert';

import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/remote_config/remote_config.dart';
import 'package:confesi/init.dart';

import '../../shared/buttons/option.dart';
import '../../shared/other/zoomable.dart';
import '../../shared/overlays/button_options_sheet.dart';

import '../tabs/trending_feed.dart';
import '../../shared/buttons/simple_text.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/layout/appbar.dart';
import '../tabs/recents_feed.dart';

/// Which type of feed is selected.
///
/// Recents or Trending.
enum SelectedFeedType {
  recents,
  trending,
}

class ExploreHome extends StatefulWidget {
  const ExploreHome({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<ExploreHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  SelectedFeedType selectedFeedType = SelectedFeedType.recents;

  void changeFeed() {
    if (selectedFeedType == SelectedFeedType.recents) {
      setState(() {
        selectedFeedType = SelectedFeedType.trending;
      });
    } else if (selectedFeedType == SelectedFeedType.trending) {
      setState(() {
        selectedFeedType = SelectedFeedType.recents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                Builder(builder: (context) {
                  return AppbarLayout(
                    bottomBorder: true,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    rightIconOnPress: () => showButtonOptionsSheet(
                      context,
                      [
                        OptionButton(
                            onTap: () => router.push("/home/profile/stats"),
                            text: "Your stats",
                            icon: CupertinoIcons.chart_bar_square),
                        OptionButton(
                            onTap: () => router.push("/home/profile/account"),
                            text: "Edit account details",
                            icon: CupertinoIcons.pencil),
                        OptionButton(
                            onTap: () => router.push("/home/profile/saved/posts"),
                            text: "Saved confessions",
                            icon: CupertinoIcons.bookmark),
                        OptionButton(
                            onTap: () => router.push("/home/profile/saved/comments"),
                            text: "Saved comments",
                            icon: CupertinoIcons.bookmark),
                        OptionButton(
                            onTap: () => router.push('/home/profile/comments'),
                            text: "Your comments",
                            icon: CupertinoIcons.chat_bubble_2),
                        OptionButton(
                            onTap: () => router.push('/home/profile/posts'),
                            text: "Your confessions",
                            icon: CupertinoIcons.cube_box),
                      ],
                    ),
                    rightIconVisible: true,
                    rightIcon: CupertinoIcons.profile_circled,
                    centerWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.chevron_back,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        SimpleTextButton(
                          onTap: () => changeFeed(),
                          text: selectedFeedType == SelectedFeedType.trending
                              ? sl.get<RemoteConfigService>().config.getString('trending_feed_btn_title')
                              : sl.get<RemoteConfigService>().config.getString('recents_feed_btn_title'),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          CupertinoIcons.chevron_forward,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        ),
                      ],
                    ),
                    leftIconVisible: true,
                    leftIcon: CupertinoIcons.slider_horizontal_3,
                    leftIconOnPress: () => widget.scaffoldKey.currentState!.openDrawer(),
                  );
                }),
                Expanded(
                  child:
                      selectedFeedType == SelectedFeedType.trending ? const ExploreTrending() : const ExploreRecents(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
