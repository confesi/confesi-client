import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';

import '../../../core/router/go_router.dart';
import 'package:flutter/services.dart';

import '../../shared/indicators/loading_or_alert.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../constants/leaderboard/general.dart';
import '../../../core/utils/dates/two_dates_same.dart';
import '../../../core/utils/dates/readable_date_format.dart';
import '../widgets/hottest_tile.dart';
import '../widgets/date_picker_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/layout/appbar.dart';

class HottestHome extends StatefulWidget {
  const HottestHome({Key? key}) : super(key: key);

  @override
  State<HottestHome> createState() => _HottestHomeState();
}

class _HottestHomeState extends State<HottestHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.95);
    context.read<HottestCubit>().loadMostRecent();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context, HottestState state) {
    if (state is DailyHottestData) {
      if (state.posts.isEmpty) {
        return Center(
          key: const ValueKey('alert'),
          child: AlertIndicator(
            btnMsg: "Load the most recent",
            message: "There are no confessions for this day",
            onPress: () => context.read<HottestCubit>().loadMostRecent(),
          ),
        );
      }
      return GestureDetector(
        onTap: () => router.push("/home/posts/comments",
            extra: HomePostsCommentsProps(PreloadedPost(state.posts[currentIndex], false))),
        child: PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (selectedIndex) {
            HapticFeedback.lightImpact();
            setState(() => currentIndex = selectedIndex);
          },
          children: state.posts
              .asMap()
              .entries
              .map((post) => HottestTile(
                    currentIndex: currentIndex,
                    thisIndex: post.key,
                    post: post.value,
                  ))
              .toList()
              .sublist(
                0,
                state.posts.length > kMaxDisplayedHottestDailyPosts
                    ? kMaxDisplayedHottestDailyPosts
                    : state.posts.length,
              ),
        ),
      );
    } else {
      return LoadingOrAlert(
        message: StateMessage(
            state is DailyHottestError ? state.message : null, () => context.read<HottestCubit>().loadMostRecent()),
        isLoading: state is! DailyHottestError,
      );
    }
  }

  String headerText = "Daily Hottest";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ThemeStatusBar(
      child: BlocListener<HottestCubit, HottestState>(
        listenWhen: (previous, current) => true,
        listener: (context, state) async {
          if (state is DailyHottestData) {
            currentIndex = 0;
            headerText = "Hottest of ${state.date.readableLocalDateFormat()}";
          }
          if (state is DailyHottestError) {
            setState(() => headerText = "Daily Hottest");
          }
          if (pageController.hasClients) {
            pageController.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                    color: Theme.of(context).colorScheme.shadow,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            BlocBuilder<HottestCubit, HottestState>(
                              builder: (context, state) {
                                return AppbarLayout(
                                  rightIcon: CupertinoIcons.smiley,
                                  rightIconVisible: true,
                                  rightIconOnPress: () => router.push("/home/emojis"),
                                  bottomBorder: true,
                                  centerWidget: Text(
                                    headerText,
                                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  leftIconVisible: true,
                                  leftIcon: CupertinoIcons.calendar,
                                  leftIconOnPress: () => showDatePickerSheet(context),
                                );
                              },
                            ),
                            Expanded(
                              child: BlocBuilder<HottestCubit, HottestState>(
                                builder: (context, state) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: buildChild(context, state),
                                  );
                                },
                                // listenWhen: ,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
