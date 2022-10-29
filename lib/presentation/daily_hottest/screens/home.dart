import 'package:Confessi/application/daily_hottest/cubit/hottest_cubit.dart';
import 'package:Confessi/core/extensions/dates/two_dates_same.dart';
import 'package:Confessi/core/extensions/dates/readable_date_format.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/hottest_tile.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/date_picker_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/daily_hottest/general.dart';
import '../../../constants/shared/enums.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/indicators/loading.dart';
import '../../shared/layout/appbar.dart';

class HottestHome extends StatefulWidget {
  const HottestHome({Key? key}) : super(key: key);

  @override
  State<HottestHome> createState() => _HottestHomeState();
}

class _HottestHomeState extends State<HottestHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final PageController pageController = PageController(viewportFraction: .9, initialPage: 0);

  int currentIndex = 0;

  Widget buildChild(BuildContext context, HottestState state) {
    if (state is Loading) {
      return const Center(
        key: ValueKey('loading'),
        child: LoadingIndicator(),
      );
    } else if (state is Data && state.posts.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/home/detail',
            arguments: {
              'id': state.posts[currentIndex].id,
              'badges': state.posts[currentIndex].badges,
              'post_child': state.posts[currentIndex].child,
              'icon': state.posts[currentIndex].icon,
              'genre': state.posts[currentIndex].genre,
              'time': state.posts[currentIndex].createdDate,
              'faculty': state.posts[currentIndex].faculty,
              'text': state.posts[currentIndex].text,
              'title': state.posts[currentIndex].title,
              'likes': state.posts[currentIndex].likes,
              'hates': state.posts[currentIndex].hates,
              'comments': state.posts[currentIndex].comments,
              'year': state.posts[currentIndex].year,
              'university': state.posts[currentIndex].university,
              'university_full_name': state.posts[currentIndex].universityFullName,
              'postView': PostView.detailView
            },
          );
        },
        child: PageView(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (selectedIndex) {
              HapticFeedback.lightImpact();
              setState(() {
                currentIndex = selectedIndex;
              });
            },
            children: state.posts
                .asMap()
                .entries
                .map((post) => HottestTile(
                      currentIndex: currentIndex,
                      thisIndex: post.key,
                      universityImagePath: post.value.universityImagePath,
                      comments: post.value.comments,
                      hates: post.value.hates,
                      likes: post.value.likes,
                      title: post.value.title,
                      text: post.value.text,
                      university: post.value.university,
                      year: post.value.year,
                    ))
                .toList()
                .sublist(
                    0,
                    state.posts.length > kMaxDisplayedHottestDailyPosts
                        ? kMaxDisplayedHottestDailyPosts
                        : state.posts.length)),
      );
    } else {
      final error = state as Error;
      return Center(
        key: const ValueKey('alert'),
        child: AlertIndicator(
          isLoading: error.retryingAfterError,
          message: error.message,
          onPress: () => context.read<HottestCubit>().loadPosts(DateTime.now()),
        ),
      );
    }
  }

  String headerText = "Hottest Today";

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: SafeArea(
        child: BlocListener<HottestCubit, HottestState>(
          listener: (context, state) {
            setState(() {
              currentIndex = 0; // To ensure the hottest tiles build and expand properly
            });
            if (state is Data) {
              setState(() {
                headerText = state.date.isSameDate(DateTime.now())
                    ? "Hottest Today"
                    : "Hottest of ${state.date.readableDateFormat()}";
              });
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: LayoutBuilder(
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
                                  centerWidget: Text(
                                    headerText,
                                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  rightIconVisible: true,
                                  rightIcon: CupertinoIcons.chart_bar,
                                  rightIconOnPress: () => Navigator.of(context).pushNamed('/hottest/leaderboard'),
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
