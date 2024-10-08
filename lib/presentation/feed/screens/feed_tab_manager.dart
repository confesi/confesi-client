import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/presentation/feed/tabs/sentiment_feed.dart';
import 'package:confesi/presentation/feed/widgets/sticky_appbar.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_action_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../shared/buttons/circle_icon_btn.dart';
import '../../shared/edited_source_widgets/text.dart';
import '../tabs/recents_feed.dart';
import '../tabs/trending_feed.dart';

const double appbarHeight = 46;

class ExploreHome extends StatefulWidget {
  const ExploreHome({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<ExploreHome> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late PageController _pageController;
  late StickyAppbarController _stickyAppbarController;

  late String emoji;

  @override
  initState() {
    super.initState();
    DefaultPostFeed defaultFeed = Provider.of<UserAuthService>(context, listen: false).data().defaultPostFeed;
    _pageController = PageController(initialPage: defaultFeed.tabIdx);
    // post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsService>().setCurrentlySelectedFeedAndReloadIfNeeded(context, defaultFeed.convertToFeedType);
    });
    emoji = genRandomEmoji(null);
    _stickyAppbarController = StickyAppbarController(this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _stickyAppbarController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  double appbarDynamicHeight = appbarHeight;

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
        bottom: false,
        top: false,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Expanded(
                child: StickyAppbar(
                  controller: _stickyAppbarController,
                  stickyHeader: StickyAppbarProps(
                    height: appbarHeight + MediaQuery.of(context).padding.top,
                    child: Container(
                      color: Theme.of(context).colorScheme.shadow,
                      padding:
                          EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 12, right: 12, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _FeedTab(
                                  isSelected: context.watch<PostsService>().currentlySelectedFeed == FeedType.recents,
                                  title: "New",
                                  onTap: () {
                                    context
                                        .read<PostsService>()
                                        .setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.recents);
                                    _pageController.jumpToPage(0);
                                  }),
                              const SizedBox(width: 10),
                              _FeedTab(
                                  isSelected: context.watch<PostsService>().currentlySelectedFeed == FeedType.trending,
                                  title: "Trending",
                                  onTap: () {
                                    context
                                        .read<PostsService>()
                                        .setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.trending);
                                    _pageController.jumpToPage(1);
                                  }),
                              const SizedBox(width: 10),
                              _FeedTab(
                                  isSelected: context.watch<PostsService>().currentlySelectedFeed == FeedType.sentiment,
                                  title: "Positivity",
                                  onTap: () {
                                    context
                                        .read<PostsService>()
                                        .setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.sentiment);
                                    _pageController.jumpToPage(2);
                                  }),
                              const Expanded(child: SizedBox(width: 10)),
                              CircleActionButton(
                                onTap: () => widget.scaffoldKey.currentState!.openDrawer(),
                                color: Theme.of(context).colorScheme.primary,
                                bgColor: Theme.of(context).colorScheme.surface,
                                icon: CupertinoIcons.line_horizontal_3_decrease,
                              ),
                              const SizedBox(width: 10),
                              CircleActionButton(
                                onTap: () => verifiedUserOnly(context, () => router.push("/home/rooms")),
                                color: Theme.of(context).colorScheme.primary,
                                bgColor: Theme.of(context).colorScheme.surface,
                                icon: CupertinoIcons.chat_bubble_2_fill,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: Container(
                    color: Theme.of(context).colorScheme.shadow,
                    child: PageView(
                      pageSnapping: true,
                      // hide scroll notifications
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (value) {
                        _stickyAppbarController.bringDownAppbar();
                        context
                            .read<PostsService>()
                            .setCurrentlySelectedFeedAndReloadIfNeeded(context, FeedType.values[value]);
                      },
                      controller: _pageController,
                      children: [
                        ExploreRecents(topOffset: appbarHeight + MediaQuery.of(context).padding.top),
                        ExploreTrending(topOffset: appbarHeight + MediaQuery.of(context).padding.top),
                        ExploreSentiment(topOffset: appbarHeight + MediaQuery.of(context).padding.top),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab({required this.isSelected, required this.title, required this.onTap});

  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptics.f(H.regular);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SafeText(
          title,
          style: kBody.copyWith(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
