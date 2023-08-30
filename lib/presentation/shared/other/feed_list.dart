import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  List<InfiniteScrollIndexable> items = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  bool isCurrentlyScrolling = false;

  void addItem(InfiniteScrollIndexable newItem) {
    if (_isDisposed) return;
    items.add(newItem);
    notifyListeners();
  }

  void notify() => notifyListeners();

  void setItems(List<InfiniteScrollIndexable> newItemList) {
    items = newItemList;
    notifyListeners();
  }

  void addItems(List<InfiniteScrollIndexable> newItems) {
    if (_isDisposed) return;
    items.addAll(newItems);
    notifyListeners();
  }

  void scrollToTop() {
    if (_isDisposed) return;
    if (isCurrentlyScrolling) return;
    isCurrentlyScrolling = true;
    if (!itemScrollController.isAttached) return;
    itemScrollController
        .scrollTo(index: 0, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut)
        .then((value) => HapticFeedback.lightImpact())
        .then((value) => isCurrentlyScrolling = false);
    notifyListeners();
  }

  int currentIndex() {
    if (_isDisposed) return 0;
    if (itemPositionsListener.itemPositions.value.isEmpty) return 0;
    return itemPositionsListener.itemPositions.value.last.index;
  }

  void scrollToIndex(int index, {bool hapticFeedback = true}) {
    if (_isDisposed) return;
    if (isCurrentlyScrolling) return;
    isCurrentlyScrolling = true;
    if (!itemScrollController.isAttached) return;
    itemScrollController
        .scrollTo(index: index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut)
        .then((value) => hapticFeedback ? HapticFeedback.lightImpact() : null)
        .then((value) => isCurrentlyScrolling = false);
  }

  void clearList() {
    if (_isDisposed) return;
    items.clear();
    notifyListeners();
  }

  List<int> currentIndexes() {
    if (_isDisposed) return [];
    if (itemPositionsListener.itemPositions.value.isEmpty) return [];
    List<int> visibleIndexes = [];
    for (var position in itemPositionsListener.itemPositions.value) {
      if (position.itemTrailingEdge > 0 && position.itemLeadingEdge < 1) {
        visibleIndexes.add(position.index);
      }
    }
    return visibleIndexes;
  }

  void _updateScrolledDownFromTop(bool newValue) {
    if (_isDisposed) return;
    scrolledDownFromTop = newValue;
    notifyListeners();
  }

  InfiniteScrollIndexable lastItem() {
    if (itemPositionsListener.itemPositions.value.isEmpty) {
      return items[0];
    }
    return items[itemPositionsListener.itemPositions.value.last.index - 1];
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
    this.swipeRefreshEnabled = true,
    this.debug = false,
    this.onScrollChange,
  });

  final bool swipeRefreshEnabled;
  final bool debug;
  final bool isScrollable;
  final bool shrinkWrap;
  final bool hasError;
  final bool wontLoadMore;
  final String wontLoadMoreMessage;
  final Widget? header;
  final FeedListController controller;
  final Function(dartz.Either<Failure, dynamic> possibleLastSeenId) loadMore;
  final Function onErrorButtonPressed;
  final Function onWontLoadMoreButtonPressed;
  final Function onPullToRefresh;
  final Function(bool start)? onScrollChange;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  bool isCurrentlyLoadingMore = false;
  bool errorLoadingMoreIsLoading = false;
  bool endOfFeedReachedIsLoading = false;
  int? lastLoadedIndex;

  @override
  void initState() {
    widget.controller.itemPositionsListener.itemPositions.addListener(() async {
      if (widget.controller.itemPositionsListener.itemPositions.value.isEmpty) return;
      widget.controller
          ._updateScrolledDownFromTop(widget.controller.itemPositionsListener.itemPositions.value.first.index >= 1);
      List<int> visibleIndexes =
          widget.controller.itemPositionsListener.itemPositions.value.map((item) => item.index).toList();
      int lastVisibleIndex = visibleIndexes.last;
      if (widget.controller.items.length - lastVisibleIndex < widget.controller.preloadBy &&
          lastLoadedIndex != lastVisibleIndex &&
          !isCurrentlyLoadingMore &&
          !widget.hasError &&
          !widget.wontLoadMore &&
          !endOfFeedReachedIsLoading &&
          !errorLoadingMoreIsLoading) {
        lastLoadedIndex = lastVisibleIndex;
        isCurrentlyLoadingMore = true;
        await widget.loadMore(
          widget.controller.items.isNotEmpty
              ? dartz.Right(widget.controller.items.last.key)
              : dartz.Left(NoneFailure()),
        );
        isCurrentlyLoadingMore = false;
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
        key: const ValueKey("has_error"),
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
        key: const ValueKey("has_end"),
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
      enabled: widget.swipeRefreshEnabled,
      onRefresh: () async => await widget.onPullToRefresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            // Scrolling has started.
            if (widget.onScrollChange != null) {
              widget.onScrollChange!(true);
            }
          } else if (scrollNotification is ScrollEndNotification) {
            // Scrolling has stopped.
            if (widget.onScrollChange != null) {
              widget.onScrollChange!(false);
            }
          }
          return false; // Returning false means the notification will continue to be dispatched to further ancestors.
        },
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
      ),
    );
  }
}
