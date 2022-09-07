import 'package:Confessi/presentation/shared/behaviours/keyboard_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';

import '../../shared/edited_source_widgets/swipe_refresh.dart';
import '../../../core/constants/feed/constants.dart';

/// Controller for the [InfiniteList].
class InfiniteController extends ChangeNotifier {
  //! Initialized variables / initialization

  /// Items that are going to be repeated inside the scrollview.
  List<int> items;

  /// The list of root indexes that can be jumped between.
  List<int> rootIndexes;

  /// What happens when you go to load more [items].
  Future<void> Function() onLoad;

  /// What happens when you refresh the screen via the [SwipeRefresh].
  Future<void> Function() onRefresh;

  /// How many items you'd like to preload by before you get to the bottom of the list.
  final int preloadBy;

  /// The current state of the feed.
  InfiniteListState feedState;

  /// A callback telling if the feed is currently scrolled to the VERY top, or not.
  void Function(bool)? atTop;

  /// Time it takes to animate to the next root index.
  Duration? scrollToRootDuration;

  /// Time it takes to fade between different screens (based upon [InfiniteListState]).
  Duration? feedFadeDuration;

  InfiniteController({
    required this.feedState,
    required this.items,
    required this.rootIndexes,
    required this.onLoad,
    required this.onRefresh,
    this.preloadBy = 5,
    this.atTop,
    this.scrollToRootDuration,
    this.feedFadeDuration,
  }) {
    scrollToRootDuration ??= const Duration(milliseconds: 250);
    feedFadeDuration ??= const Duration(milliseconds: 250);
  }

  //! Variables

  /// Last visible index inside the viewport.
  int lastVisibleIndex = 0;

  /// First visible index inside the viewport.
  int firstVisibleIndex = 0;

  /// If loading is currently happening.
  bool isLoadingMore = false;

  /// Controller 1 for [ScrollablePositionedList].
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Controller 2 for [ScrollablePositionedList].
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  //! Listeners

  void initializeListeners() {
    itemPositionsListener.itemPositions.addListener(() async {
      // At top logic.
      if (itemPositionsListener.itemPositions.value.isNotEmpty &&
          itemPositionsListener.itemPositions.value.toList()[0].index == 0 &&
          itemPositionsListener.itemPositions.value
                  .toList()[0]
                  .itemLeadingEdge ==
              0 &&
          atTop != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          atTop!(true);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          atTop!(false);
        });
      }
      // Loading more/animate to root logic.
      List<int> visibleIndexes = itemPositionsListener.itemPositions.value
          .map((item) => item.index)
          .toList();
      if (visibleIndexes.isNotEmpty) {
        lastVisibleIndex = visibleIndexes.last;
        firstVisibleIndex = itemPositionsListener.itemPositions.value
            .toList()
            .reduce((curr, next) => curr.index < next.index ? curr : next)
            .index;
        notifyListeners();
      }
      if (items.length - lastVisibleIndex < preloadBy &&
          !isLoadingMore &&
          feedState == InfiniteListState.feedLoading) {
        isLoadingMore = true;
        await onLoad();
        isLoadingMore = false;
      }
    });
  }

  /// Add items to the [items] list.
  void addItems(List<int> newItems) {
    items.addAll(newItems);
    notifyListeners();
  }

  /// Clear all items from the [items] list.
  void clearItems() {
    items.clear();
    notifyListeners();
  }

  /// Set a whole new value for the [items] list.
  void setItems(List<int> newItems) {
    items = newItems;
    notifyListeners();
  }

  /// Scroll down to the closest root.
  void scrollDownToRoot() async {
    if (items.isEmpty) return;
    int? result =
        rootIndexes.firstWhereOrNull((element) => element > firstVisibleIndex);
    if (result != null && result < items.length) {
      itemScrollController.scrollTo(
        curve: Curves.easeInOutCubic,
        index: result,
        duration: scrollToRootDuration!,
      );
    } else {
      //! Pondering keeping this in: if there's no below root loaded or in view, then scoll
      //! to the last visible index
      // itemScrollController.scrollTo(
      //   curve: Curves.easeInOutCubic,
      //   index: lastVisibleIndex,
      //   duration: scrollToRootDuration!,
      // );
    }
  }

  /// Scroll up to the closest root.
  void scrollUpToRoot() async {
    if (items.isEmpty) return;
    int? result = rootIndexes.reversed
        .firstWhereOrNull((element) => element < firstVisibleIndex);
    if (result != null && result < items.length) {
      itemScrollController.scrollTo(
        curve: Curves.easeInOutCubic,
        index: result,
        duration: scrollToRootDuration!,
      );
    } else {
      itemScrollController.scrollTo(
        curve: Curves.easeInOutCubic,
        index: 0,
        duration: scrollToRootDuration!,
      );
    }
  }

  /// Scroll to the very top of the scrollview.
  void scrollToTop() async {
    itemScrollController.jumpTo(
      index: 0,
    );
  }

  /// Set the current [InfiniteListState].
  void setFeedState(InfiniteListState newFeedState) {
    feedState = newFeedState;
    notifyListeners();
  }
}

class InfiniteList extends StatefulWidget {
  const InfiniteList({
    required this.controller,
    this.header,
    required this.fullPageLoading,
    required this.fullPageError,
    required this.fullPageEmpty,
    required this.feedLoading,
    required this.feedError,
    required this.feedEmpty,
    this.refreshIndicatorBackgroundColor,
    this.refreshIndicatorColor,
    this.refreshIndicatorShadowColor,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  final InfiniteController controller;
  final Widget? header;
  final Widget fullPageLoading;
  final Widget fullPageError;
  final Widget fullPageEmpty;
  final Widget feedLoading;
  final Widget feedError;
  final Widget feedEmpty;
  final Color? refreshIndicatorColor;
  final Color? refreshIndicatorBackgroundColor;
  final Color? refreshIndicatorShadowColor;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  State<InfiniteList> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  @override
  void initState() {
    // Initializes listeners on the [InfiniteController].
    widget.controller.initializeListeners();
    super.initState();
  }

  /// Builds the different children based on [InfiniteListState].
  Widget buildRouter() {
    switch (widget.controller.feedState) {
      case InfiniteListState.feedLoading:
        return Container(key: UniqueKey(), child: widget.feedLoading);
      case InfiniteListState.feedEmpty:
        return Container(key: UniqueKey(), child: widget.feedEmpty);
      case InfiniteListState.feedError:
        return Container(key: UniqueKey(), child: widget.feedError);
      default:
        throw UnimplementedError(
            'Feedstate ${widget.controller.feedState} not implemented');
    }
  }

  /// Builds different pages based on [InfiniteListState].
  Widget buildPage() {
    switch (widget.controller.feedState) {
      case InfiniteListState.fullPageLoading:
        return Container(key: UniqueKey(), child: widget.fullPageLoading);
      case InfiniteListState.fullPageEmpty:
        return Container(key: UniqueKey(), child: widget.fullPageEmpty);
      case InfiniteListState.fullPageError:
        return Container(key: UniqueKey(), child: widget.fullPageError);
      default:
        return buildList();
    }
  }

  /// Builds the infnite list.
  Widget buildList() => KeyboardDismissLayout(
        child: GestureDetector(
          onVerticalDragDown: (details) => FocusScope.of(context).unfocus(),
          child: SwipeRefresh(
            shadowColor: widget.refreshIndicatorShadowColor,
            color: widget.refreshIndicatorColor,
            backgroundColor: widget.refreshIndicatorBackgroundColor,
            onRefresh: () async => widget.controller.onRefresh(),
            child: ScrollablePositionedList.builder(
              physics: AlwaysScrollableScrollPhysics(
                parent: widget.controller.items.isEmpty
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return widget.header ?? Container();
                } else if (index == widget.controller.items.length + 1) {
                  return buildRouter();
                } else {
                  return widget.itemBuilder(context, index);
                }
              },
              itemCount: widget.controller.items.length + 2,
              itemPositionsListener: widget.controller.itemPositionsListener,
              itemScrollController: widget.controller.itemScrollController,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.controller.feedFadeDuration!,
      child: buildPage(),
    );
  }
}
