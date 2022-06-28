import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/messages/explore_feed.dart';
import 'package:flutter_mobile_client/widgets/scrollables/scrollable.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/tiles/highlight.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import '../../constants/typography.dart';

enum FetchType {
  morePosts,
  refreshPosts,
}

class InfiniteScrollable extends StatefulWidget {
  const InfiniteScrollable(
      {required this.refreshPosts,
      required this.currentlyFetching,
      required this.hasError,
      required this.noMorePosts,
      required this.fetchMorePosts,
      required this.posts,
      required this.dailyPosts,
      Key? key})
      : super(key: key);

  final List<Widget> posts;
  final List<Widget> dailyPosts;
  final Function fetchMorePosts;
  final Function refreshPosts;

  // all false by default
  final bool currentlyFetching;
  final bool hasError;
  final bool noMorePosts;

  @override
  State<InfiniteScrollable> createState() => _InfiniteScrollableState();
}

class _InfiniteScrollableState extends State<InfiniteScrollable> {
  bool fetching = false;

  @override
  void initState() {
    itemPositionsListener.itemPositions.addListener(() {
      final indicies = itemPositionsListener.itemPositions.value.map((post) => post.index);
      // print(
      //     "indicies: $indicies, detail: ${indicies.toList().last}, posts length: ${widget.posts.length}");
      // can add check if the list is at least x long, then check back to reload preemtively by x items
      if (widget.currentlyFetching == false &&
          widget.noMorePosts == false &&
          widget.hasError == false &&
          // the right part of this last condition is something to do with the number of posts being received at a time, the length of total widgets (remember 1 or 2 are loader and sized box?)
          indicies.toList().last >= widget.posts.length - 4) {
        print("PASSED");
        getPosts(FetchType.morePosts);
      }
    });
    super.initState();
  }

  void getPosts(FetchType fetchType) async {
    if (fetching) return;
    fetching = true;
    if (fetchType == FetchType.morePosts) {
      // await Future.delayed(const Duration(seconds: 2));
      await widget.fetchMorePosts();
    } else {
      await widget.refreshPosts();
    }
    fetching = false;
  }

  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();

  Widget infiniteList() {
    return ScrollConfiguration(
      behavior: NoOverScrollSplash(),
      child: ScrollablePositionedList.builder(
        physics: const ClampingScrollPhysics(),
        itemPositionsListener: itemPositionsListener,
        itemScrollController: itemScrollController,
        itemCount: widget.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? Column(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Hottest posts today",
                                    style: kHeader.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.ellipsis,
                                  color: Theme.of(context).colorScheme.onBackground,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: widget.dailyPosts.isEmpty
                                ? const Center(
                                    child: CupertinoActivityIndicator(),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        children: widget.dailyPosts,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: widget.posts[index],
                    )
                  ],
                )
              : index < widget.posts.length
                  ? widget.posts[index]
                  : widget.hasError
                      ? ScrollableIndicator(
                          text: kScrollableError,
                          onPress: () => getPosts(FetchType.morePosts),
                        )
                      : widget.noMorePosts
                          ? ScrollableIndicator(
                              text: kScrollableNoMorePosts,
                              onPress: () => getPosts(FetchType.morePosts),
                            )
                          : const ScrollableIndicator(spinner: true);
        },
      ),
    );
  }

  Widget spinner() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget error() {
    return ScrollableIndicator(
      text: kFullscreenError,
      onPress: () => getPosts(FetchType.refreshPosts),
    );
  }

  Widget empty() {
    return ScrollableIndicator(
      text: kFullscreenNoPostsFound,
      onPress: () => getPosts(FetchType.refreshPosts),
    );
  }

  Widget getBody() {
    // checks if posts array is empty
    if (widget.posts.isEmpty) {
      // no posts
      if (widget.hasError) {
        return error();
      } else if (widget.noMorePosts) {
        return empty();
      } else {
        return spinner();
      }
    } else {
      // has posts
      return infiniteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      // // extentPercentageToArmed: .35,
      // offsetToArmed: 0.0,
      onRefresh: () async {
        getPosts(FetchType.refreshPosts);
        HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 400));
      },
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, _) {
                    return Container(
                      color: Theme.of(context).colorScheme.secondary,
                      width: double.infinity,
                      height: controller.value * 50,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: CupertinoActivityIndicator(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    );
                  },
                ),
                Transform.translate(
                  offset: Offset(0, controller.value * 50),
                  child: child,
                ),
              ],
            );
          },
        );
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            FadeTransition(opacity: animation, child: child),
        child: getBody(),
      ),
    );
  }
}
