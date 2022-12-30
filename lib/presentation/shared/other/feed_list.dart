import '../edited_source_widgets/swipe_refresh.dart';
import '../indicators/alert.dart';
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
  List<Widget> items = [];
  // Controller 1 for [ScrollablePositionedList].
  final ItemScrollController itemScrollController = ItemScrollController();

  // Controller 2 for [ScrollablePositionedList].
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  /// Adds an item to the list.
  void addItem(Widget newItem) {
    if (_isDisposed) return;
    items.add(newItem);
    notifyListeners();
  }

  /// Sets the items list to a whole new set of values.
  void setItems(List<Widget> newItemList) {
    if (_isDisposed) return;
    items = newItemList;
    notifyListeners();
  }

  /// Adds multiple items to the list.
  void addItems(List<Widget> newItems) {
    if (_isDisposed) return;

    items.addAll(newItems);
    notifyListeners();
  }

  /// Scrolls to the top of the list (over a set duration).
  void scrollToTop() {
    if (_isDisposed) return;

    itemScrollController.scrollTo(index: 0, duration: const Duration(milliseconds: 350));
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
  Widget lastItem() {
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
    required this.hasReachedEnd,
    required this.onEndOfFeedReachedButtonPressed,
    required this.onErrorButtonPressed,
  });

  final bool hasError;
  final bool hasReachedEnd;
  final Widget? header;
  final FeedListController controller;
  final Function loadMore;
  final Function onErrorButtonPressed;
  final Function onEndOfFeedReachedButtonPressed;
  final Function onPullToRefresh;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  bool isCurrentlyLoadingMorePosts = false;
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
          !isCurrentlyLoadingMorePosts &&
          !widget.hasError &&
          !widget.hasReachedEnd) {
        isCurrentlyLoadingMorePosts = true;
        await widget.loadMore();
        isCurrentlyLoadingMorePosts = false;
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
      return _FeedListIndicator(
        isLoading: errorLoadingMoreIsLoading,
        message: "Error loading more.",
        onClick: () async {
          setState(() {
            errorLoadingMoreIsLoading = true;
          });
          await widget.onErrorButtonPressed();
          setState(() {
            errorLoadingMoreIsLoading = false;
          });
        },
      );
    } else if (widget.hasReachedEnd) {
      return _FeedListIndicator(
        isLoading: endOfFeedReachedIsLoading,
        message: "You've reached the end!",
        onClick: () async {
          setState(() {
            endOfFeedReachedIsLoading = true;
          });
          await widget.onEndOfFeedReachedButtonPressed();
          setState(() {
            endOfFeedReachedIsLoading = false;
          });
        },
      );
    } else {
      return const _FeedListIndicator(isLoading: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeRefresh(
      onRefresh: () async => await widget.onPullToRefresh(),
      child: ScrollablePositionedList.builder(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 0),
              child: widget.header ?? Container(),
            );
          } else if (index == widget.controller.items.length + 1) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: buildIndicator(),
            );
          } else {
            return widget.controller.items[index - 1];
          }
        },
        itemCount: widget.controller.items.length + 2,
        itemPositionsListener: widget.controller.itemPositionsListener,
        itemScrollController: widget.controller.itemScrollController,
      ),
    );
  }
}

//! Feed alert widget

class _FeedListIndicator extends StatelessWidget {
  const _FeedListIndicator({super.key, this.message, this.onClick, required this.isLoading});

  final String? message;
  final VoidCallback? onClick;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: message != null && onClick != null && !isLoading
                ? AlertIndicator(
                    message: message!,
                    onPress: () => onClick!(),
                  )
                : const CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}
