import 'package:confesi/presentation/feed/tabs/sentiment_feed.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/router/go_router.dart';
import '../../shared/buttons/circle_emoji_button.dart';
import '../../shared/layout/appbar.dart';
import '../tabs/recents_feed.dart';
import '../tabs/trending_feed.dart';

enum FeedType {
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
  final PageController _pageController = PageController(initialPage: 0);
  FeedType selectedFeedType = FeedType.recents;

  @override
  bool get wantKeepAlive => true;

  void changeFeed() {
    int currentPage = _pageController.page?.toInt() ?? 0;
    int nextPage = (currentPage + 1) % FeedType.values.length;
    setState(() {
      selectedFeedType = FeedType.values[nextPage];
    });
    _pageController.jumpToPage(nextPage);
  }

  void previousPage() {
    int currentPage = _pageController.page?.toInt() ?? 0;
    int previousPage = (currentPage - 1) % FeedType.values.length;
    setState(() {
      selectedFeedType = FeedType.values[previousPage];
    });
    _pageController.jumpToPage(previousPage);
  }

  void nextPage() {
    int currentPage = _pageController.page?.toInt() ?? 0;
    int nextPage = (currentPage + 1) % FeedType.values.length;
    setState(() {
      selectedFeedType = FeedType.values[nextPage];
    });
    _pageController.jumpToPage(nextPage);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.shadow,
          child: Column(
            children: [
              AppbarLayout(
                bottomBorder: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                rightIconOnPress: () => router.push('/home/notifications'),
                rightIconVisible: true,
                rightIcon: CupertinoIcons.bell,
                centerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TouchableOpacity(
                      onTap: () => previousPage(),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          CupertinoIcons.chevron_back,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: CircleEmojiButton(
                        onTap: () => changeFeed(),
                        text: selectedFeedType == FeedType.sentiment
                            ? 'Positivity ✨'
                            : selectedFeedType == FeedType.trending
                                ? 'Trending 🔥'
                                : 'Recents ⏳',
                      ),
                    ),
                    TouchableOpacity(
                      onTap: () => nextPage(),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                leftIconVisible: true,
                leftIcon: CupertinoIcons.slider_horizontal_3,
                leftIconOnPress: () => widget.scaffoldKey.currentState!.openDrawer(),
              ),
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(), // Add this line

                  onPageChanged: (value) => setState(() {
                    selectedFeedType = FeedType.values[value];
                  }),
                  controller: _pageController,
                  itemCount: FeedType.values.length,
                  itemBuilder: (context, index) {
                    FeedType feedType = FeedType.values[index];
                    return feedType == FeedType.trending
                        ? const ExploreTrending()
                        : feedType == FeedType.sentiment
                            ? const ExploreSentiment()
                            : const ExploreRecents();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
