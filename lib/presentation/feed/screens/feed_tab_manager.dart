import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/presentation/feed/tabs/sentiment_feed.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../shared/buttons/circle_emoji_button.dart';
import '../../shared/layout/appbar.dart';
import '../tabs/recents_feed.dart';
import '../tabs/trending_feed.dart';

class ExploreHome extends StatefulWidget {
  const ExploreHome({
    Key? key,
    required this.scaffoldKey,
    required this.recentsFeedListController,
    required this.trendingFeedListController,
    required this.sentimentFeedListController,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final FeedListController recentsFeedListController;
  final FeedListController trendingFeedListController;
  final FeedListController sentimentFeedListController;

  @override
  State<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<ExploreHome> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  bool get wantKeepAlive => true;

  void previousPage() {
    HapticFeedback.lightImpact();
    int currentPage = _pageController.page?.toInt() ?? 0;

    int previousPage = currentPage - 1;
    if (previousPage < 0) {
      previousPage = FeedType.values.length - 1;
    }

    context.read<PostsService>().setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.values[previousPage]);
    _pageController.jumpToPage(previousPage);
  }

  void nextPage() {
    HapticFeedback.lightImpact();
    int currentPage = _pageController.page?.toInt() ?? 0;

    int nextPage = (currentPage + 1) % FeedType.values.length;

    context.read<PostsService>().setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.values[nextPage]);
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
                      child: GestureDetector(
                        // swipe left & right to switch forward/back
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            previousPage();
                          } else if (details.primaryVelocity! < 0) {
                            nextPage();
                          }
                        },
                        child: CircleEmojiButton(
                          onTap: () => nextPage(),
                          text: context.watch<PostsService>().currentlySelectedFeed == FeedType.sentiment
                              ? 'Positivity ✨'
                              : context.watch<PostsService>().currentlySelectedFeed == FeedType.trending
                                  ? 'Trending 🔥'
                                  : 'Recents ⏳',
                        ),
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
                child: PageView(
                  physics: const BouncingScrollPhysics(), // Add this line
                  onPageChanged: (value) {
                    context
                        .read<PostsService>()
                        .setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.values[value]);
                  },
                  controller: _pageController,
                  children: [
                    ExploreRecents(feedController: widget.recentsFeedListController),
                    ExploreTrending(feedController: widget.trendingFeedListController),
                    ExploreSentiment(feedController: widget.sentimentFeedListController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
