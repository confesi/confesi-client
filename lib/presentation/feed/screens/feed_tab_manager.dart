import '../../../core/router/go_router.dart';

import '../../shared/buttons/circle_emoji_button.dart';

import '../tabs/trending_feed.dart';

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
  sentiment,
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
        selectedFeedType = SelectedFeedType.sentiment;
      });
    } else if (selectedFeedType == SelectedFeedType.sentiment) {
      setState(() {
        selectedFeedType = SelectedFeedType.recents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ThemeStatusBar(
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
                    rightIconOnPress: () => router.push('/home/notifications'),
                    rightIconVisible: true,
                    rightIcon: CupertinoIcons.bell,
                    centerWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   CupertinoIcons.chevron_back,
                        //   color: Theme.of(context).colorScheme.onSurface,
                        //   size: 20,
                        // ),
                        // const SizedBox(width: 5),
                        CircleEmojiButton(
                          onTap: () => changeFeed(),
                          text: selectedFeedType == SelectedFeedType.sentiment
                              ? 'Positivity ✨'
                              : selectedFeedType == SelectedFeedType.trending
                                  ? 'Trending 🔥'
                                  : 'Recents ⏳',
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
