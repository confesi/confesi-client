import 'package:Confessi/presentation/feed/tabs/trending_feed.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';

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

  SelectedFeedType selectedFeedType = SelectedFeedType.trending;

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
                    rightIconOnPress: () => Navigator.of(context).pushNamed("/create_post"),
                    rightIconVisible: true,
                    rightIcon: CupertinoIcons.add,
                    bottomBorder: false,
                    centerWidget: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SimpleTextButton(
                        onTap: () => changeFeed(),
                        text: selectedFeedType == SelectedFeedType.trending ? "TrendingsNews" : "Recents",
                      ),
                    ),
                    leftIconVisible: true,
                    leftIcon: CupertinoIcons.slider_horizontal_3,
                    leftIconOnPress: () => widget.scaffoldKey.currentState!.openDrawer(),
                  );
                }),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration.zero,
                    child: selectedFeedType == SelectedFeedType.trending
                        ? const ExploreTrending()
                        : const ExploreRecents(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
