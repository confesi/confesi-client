import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

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
      Key? key})
      : super(key: key);

  final List<Widget> posts;
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
    // widget.refreshPosts();
    itemPositionsListener.itemPositions.addListener(() {
      final indicies = itemPositionsListener.itemPositions.value.map((post) => post.index);
      // print(
      //     "indicies: $indicies, detail: ${indicies.toList().last}, posts length: ${widget.posts.length}");
      // can add check if the list is at least x long, then check back to reload preemtively by x items
      if (widget.currentlyFetching == false &&
          widget.noMorePosts == false &&
          widget.hasError == false &&
          // the right part of this last condition is something to do with the number of posts being received at a time, the length of total widgets (remember 1 or 2 are loader and sized box?)
          indicies.toList().last >= widget.posts.length - 3) {
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
          return index < widget.posts.length
              ? widget.posts[index]
              : widget.hasError
                  ? TextButton(
                      onPressed: () => getPosts(FetchType.refreshPosts),
                      child: const Text("error loading more, try again"),
                    )
                  : widget.noMorePosts
                      ? TextButton(
                          onPressed: () => getPosts(FetchType.refreshPosts),
                          child: const Text("out of posts, try loading more"),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: CupertinoActivityIndicator(),
                        );
        },
      ),
    );
  }

  Widget spinner() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget error() {
    return Center(
        child: TextButton(
      onPressed: () => getPosts(FetchType.refreshPosts),
      child: const Text("error loading, try again"),
    ));
  }

  Widget empty() {
    return Center(
        child: TextButton(
      onPressed: () => getPosts(FetchType.refreshPosts),
      child: const Text("out of posts, try loading more (full screen)"),
    ));
  }

  Widget getBody() {
    // checks if posts array is empty or equal to one (one becuase the first will be a sized box)
    if (widget.posts.isEmpty || widget.posts.length == 1) {
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
      offsetToArmed: 0,
      onRefresh: () async {
        getPosts(FetchType.refreshPosts);
        HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 400));
      },
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Padding(
              padding: EdgeInsets.only(top: !controller.isIdle ? 15.0 * controller.value : 0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  if (!controller.isIdle)
                    Transform.scale(
                      scale: controller.value >= 1 ? 1 : controller.value,
                      child: const CupertinoActivityIndicator(),
                    ),
                  Opacity(
                    opacity: controller.isArmed || controller.isLoading
                        ? controller.value > 1
                            ? 1
                            : controller.value
                        : 1,
                    child: Transform.translate(
                      offset: Offset(0, 25.0 * controller.value),
                      child: child,
                    ),
                  )
                ],
              ),
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
