import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/results/failures.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../../core/types/infinite_scrollable_indexable.dart';
import '../indicators/loading_or_alert.dart';
import '../edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FeedListController extends ChangeNotifier {
  bool _isDisposed = false;

  bool scrolledDownFromTop = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // How many items to preload the feed by.
  final int preloadBy;

  FeedListController({this.preloadBy = 8});

  // Items to be in the feed.
  List<InfiniteScrollIndexable> items = [];
  // Controller 1 for [ScrollablePositionedList].
  final ItemScrollController itemScrollController = ItemScrollController();

  // Controller 2 for [ScrollablePositionedList].
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  /// Adds an item to the list.
  void addItem(InfiniteScrollIndexable newItem) {
    if (_isDisposed) return;
    items.add(newItem);
    notifyListeners();
  }

  void notify() => notifyListeners();

  /// Sets the items list to a whole new set of values.
  void setItems(List<InfiniteScrollIndexable> newItemList) {
    items = newItemList;
    notifyListeners();
  }

  /// Adds multiple items to the list.
  void addItems(List<InfiniteScrollIndexable> newItems) {
    if (_isDisposed) return;

    items.addAll(newItems);
    notifyListeners();
  }

  /// Scrolls to the top of the list (over a set duration).
  void scrollToTop() {
    if (_isDisposed) return;
    if (!itemScrollController.isAttached) return;

    itemScrollController
        .scrollTo(index: 0, duration: const Duration(milliseconds: 350))
        .then((value) => HapticFeedback.lightImpact());
  }

  /// Clears the list.
  void clearList() {
    if (_isDisposed) return;

    items.clear();
    notifyListeners();
  }

  void _updateScrolledDownFromTop(bool newValue) {
    if (_isDisposed) return;
    scrolledDownFromTop = newValue;
    notifyListeners();
  }

  /// Returns the last item loaded.
  InfiniteScrollIndexable lastItem() {
    return items[itemPositionsListener.itemPositions.value.last.index];
  }
}

class FeedList extends StatefulWidget {
  const FeedList({
    super.key,
    this.header,
    required this.controller,
    required this.loadMore,
    required this.onPullToRefresh,
    required this.hasError,
    required this.wontLoadMore,
    required this.onWontLoadMoreButtonPressed,
    required this.onErrorButtonPressed,
    required this.wontLoadMoreMessage,
    this.shrinkWrap = false,
    this.isScrollable = true,
  });

  final bool isScrollable;
  final bool shrinkWrap;
  final bool hasError;
  final bool wontLoadMore;
  final String wontLoadMoreMessage;
  final Widget? header;
  final FeedListController controller;
  final Function(dartz.Either<Failure, int> possibleLastSeenId) loadMore;
  final Function onErrorButtonPressed;
  final Function onWontLoadMoreButtonPressed;
  final Function onPullToRefresh;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  bool isCurrentlyLoadingMore = false;
  bool errorLoadingMoreIsLoading = false;
  bool endOfFeedReachedIsLoading = false;

  @override
  void initState() {
    widget.controller.itemPositionsListener.itemPositions.addListener(() async {
      // Checking if you're scrolled down past the 1st index (inclusive)
      if (widget.controller.itemPositionsListener.itemPositions.value.first.index >= 1) {
        widget.controller._updateScrolledDownFromTop(true);
      } else {
        widget.controller._updateScrolledDownFromTop(false);
      }
      // Loading more items
      List<int> visibleIndexes =
          widget.controller.itemPositionsListener.itemPositions.value.map((item) => item.index).toList();
      if (visibleIndexes.isNotEmpty &&
          widget.controller.items.length - visibleIndexes.last < widget.controller.preloadBy &&
          !isCurrentlyLoadingMore &&
          !widget.hasError &&
          !widget.wontLoadMore &&
          !endOfFeedReachedIsLoading &&
          // !widget.dontReRequestWhen &&
          !errorLoadingMoreIsLoading) {
        isCurrentlyLoadingMore = true;
        await widget.loadMore(
          widget.controller.items.isNotEmpty ? dartz.Right(widget.controller.items.last.id) : dartz.Left(NoneFailure()),
        );
        isCurrentlyLoadingMore = false;
      } else {
        widget.controller.notify();
      }
    });
    widget.controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  Widget buildIndicator() {
    if (widget.hasError) {
      return LoadingOrAlert(
        key: const ValueKey("hasError"),
        isLoading: errorLoadingMoreIsLoading,
        message: StateMessage("Error loading more", () async {
          if (!mounted) return;
          setState(() {
            errorLoadingMoreIsLoading = true;
          });
          await widget.onErrorButtonPressed();
          if (!mounted) return;
          setState(() {
            errorLoadingMoreIsLoading = false;
          });
        }),
      );
    } else {
      return LoadingOrAlert(
        key: const ValueKey("hasEnd"),
        isLoading: endOfFeedReachedIsLoading || (!widget.hasError && !widget.wontLoadMore),
        message: StateMessage(widget.wontLoadMoreMessage, () async {
          if (!mounted) return;
          setState(() {
            endOfFeedReachedIsLoading = true;
          });
          await widget.onWontLoadMoreButtonPressed();
          if (!mounted) return;
          setState(() {
            endOfFeedReachedIsLoading = false;
          });
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeRefresh(
      onRefresh: () async => await widget.onPullToRefresh(),
      child: ScrollablePositionedList.builder(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.isScrollable
            ? const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics())
            : const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return widget.header ?? const SizedBox();
          } else if (index == widget.controller.items.length + 1) {
            return AnimatedSwitcher(
              key: const ValueKey("AnimSwitcher"),
              duration: const Duration(milliseconds: 250),
              child: buildIndicator(),
            );
          } else {
            return widget.controller.items[index - 1].child;
          }
        },
        itemCount: widget.controller.items.length + 2,
        itemPositionsListener: widget.controller.itemPositionsListener,
        itemScrollController: widget.controller.itemScrollController,
      ),
    );
  }
}
