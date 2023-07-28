import '../../../core/router/go_router.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/services.dart';

import '../../shared/indicators/loading_cupertino.dart';

import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../constants/leaderboard/general.dart';
import '../../../core/extensions/dates/two_dates_same.dart';
import '../../../core/extensions/dates/readable_date_format.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context, HottestState state) {
    if (state is DailyHottestLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: LoadingCupertinoIndicator(),
      );
    } else if (state is DailyHottestData) {
      if (state.posts.isEmpty) {
        return Center(
          key: const ValueKey('alert'),
          child: AlertIndicator(
            btnMsg: "Jump to yesterday",
            message: "There are no confessions for this date",
            onPress: () => context.read<HottestCubit>().loadYesterday(),
          ),
        );
      }
      return PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (selectedIndex) {
            HapticFeedback.lightImpact();
            setState(() => currentIndex = selectedIndex);
          },
          children: state.posts
              .asMap()
              .entries
              .map((post) => TouchableScale(
                    onTap: () => router.push("/home/posts/detail"),
                    child: HottestTile(
                      currentIndex: currentIndex,
                      thisIndex: post.key,
                      post: post.value,
                    ),
                  ))
              .toList()
              .sublist(
                  0,
                  state.posts.length > kMaxDisplayedHottestDailyPosts
                      ? kMaxDisplayedHottestDailyPosts
                      : state.posts.length));
    } else {
      final error = state as DailyHottestError;
      return Center(
        key: const ValueKey('alert'),
        child: AlertIndicator(
          isLoading: true, // todo: fix this
          message: error.message,
          onPress: () => context.read<HottestCubit>().loadYesterday(),
        ),
      );
    }
  }

  String headerText = "Yesterday's Hottest";

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: BlocListener<HottestCubit, HottestState>(
        listenWhen: (previous, current) => true,
        listener: (context, state) async {
          if (state is DailyHottestData) {
            headerText = state.date.isSameDate(DateTime.now().toUtc().subtract(const Duration(days: 1)))
                ? headerText
                : "Hottest of ${state.date.readableDateFormat()}";
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
                                    duration: const Duration(milliseconds: 500),
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
