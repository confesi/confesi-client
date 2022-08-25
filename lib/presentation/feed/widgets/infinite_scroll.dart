import 'package:Confessi/presentation/shared/behaviours/overscroll.dart';
import 'package:Confessi/presentation/feed/widgets/post_tile.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/feed/constants.dart';
import '../../../domain/feed/entities/post.dart';
import 'error_message.dart';

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({
    required this.onLoad,
    required this.onRefresh,
    required this.items,
    required this.feedState,
    Key? key,
  }) : super(key: key);

  final Function onLoad;
  final Function onRefresh;
  final List<Post> items;
  final FeedState feedState;

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  bool isRefreshing = false;
  late ScrollController scrollController;
  bool isLoading = false;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          isLoading == false &&
          widget.feedState == FeedState.loadingMore) {
        isLoading = true;
        await widget.onLoad();
        isLoading = false;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchMore());
    super.initState();
  }

  Future<void> _fetchMore() async {
    // await widget.onLoad();
    if (scrollController.offset == scrollController.position.maxScrollExtent &&
        isLoading == false &&
        widget.feedState == FeedState.loadingMore) {
      isLoading = true;
      await widget.onLoad();
      isLoading = false;
      // If the posts don't fill the entire height of the screen, wait x time, and then load more.
      await Future.delayed(const Duration(milliseconds: 400));
      _fetchMore();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildFeed() {
    return ScrollConfiguration(
      behavior: NoOverScrollSplash(),
      child: ListView.builder(
        physics: const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        controller: scrollController,
        itemCount: widget.items.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.items.length) {
            return Padding(
              padding: index == 0
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(top: 16),
              child: PostTile(
                badges: widget.items[index].badges,
                postChild: widget.items[index].child,
                icon: widget.items[index].icon,
                genre: widget.items[index].genre,
                time: widget.items[index].createdDate,
                faculty: widget.items[index].faculty,
                text: widget.items[index].text,
                title: widget.items[index].title,
                likes: widget.items[index].likes,
                hates: widget.items[index].hates,
                comments: widget.items[index].comments,
                year: widget.items[index].year,
                university: widget.items[index].university,
              ),
            );
          } else {
            return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 100),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Center(
                  child: _buildIndicator(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // TODO: wrap in same animator fade?
  Widget _buildIndicator() {
    switch (widget.feedState) {
      case FeedState.errorLoadingMore:
        return ErrorMessage(
          key: UniqueKey(),
          headerText: kErrorLoadingMoreHeader,
          bodyText: kErrorLoadingMoreBody,
          onTap: () => widget.onLoad(),
        );
      case FeedState.loadingMore:
        return const CupertinoActivityIndicator(radius: 12);
      case FeedState.reachedEnd:
        return ErrorMessage(
          key: UniqueKey(),
          headerText: kReachedEndHeader,
          bodyText: kReachedEndBody,
          onTap: () => widget.onLoad(),
        );
      case FeedState.errorRefreshing:
        return ErrorMessage(
          key: UniqueKey(),
          headerText: kErrorLoadingMoreHeader,
          bodyText: kErrorLoadingMoreBody,
          onTap: () => widget.onLoad(),
        );
      default:
        throw UnimplementedError(
            "The FeedState you're trying to develop doesn't have a case yet in the InfiniteScroll widget.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: scrollController,
      child: CustomRefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          setState(() {
            isRefreshing = true;
          });
          await Future.delayed(const Duration(milliseconds: 400));
          await widget.onRefresh();
          setState(() {
            isRefreshing = false;
          });
          await Future.delayed(const Duration(milliseconds: 400));
          _fetchMore();
        },
        builder: (BuildContext context, Widget child,
            IndicatorController controller) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              return Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, _) {
                      return Container(
                        color: Theme.of(context).colorScheme.shadow,
                        width: double.infinity,
                        height: controller.value * 80,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CupertinoActivityIndicator(
                              radius: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Transform.translate(
                    offset: Offset(0, controller.value * 80),
                    child: child,
                  ),
                ],
              );
            },
          );
        },
        child: AbsorbPointer(
          absorbing: isRefreshing,
          child: _buildFeed(),
        ),
      ),
    );
  }
}


// widget.items[index].faculty