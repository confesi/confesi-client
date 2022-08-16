import 'package:Confessi/core/widgets/layout/keyboard_dismiss.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';

/// Controller that manages how the [InfiniteCommentThread] is run.
///
/// The [T] (type) argument is the type of comment that you're using.
/// For example, it may be "Comment".
class InfiniteCommentThreadController<T> extends ChangeNotifier {
  InfiniteCommentThreadController({this.onRefresh, this.comments});

  /// DO NOT USE. This field is automatically populated.
  Future<void> Function()? onRefresh;

  /// DO NOT USE. This field is automatically populated.
  List<T>? comments;

  // List of the root comment locations (their indexes).
  List<int> _rootIndexes = [];

  /// Gets the indexes of the root comments.
  List<int> get rootIndexes => _rootIndexes;

  // Global key that references the custom refresh indicator.
  final GlobalKey<CustomRefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<CustomRefreshIndicatorState>();

  // If the refresh animation is currently playing or not.
  bool _isDoingRefreshAnim = false;

  // Gets whether the refresh animation is currently playing or not.
  bool get isDoingRefreshAnim => _isDoingRefreshAnim;

  // Item scroll controller for ScrollablePositionedList.
  final ItemScrollController _itemScrollController = ItemScrollController();

  // The item posisions listener for ScrollablePositionedList.
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // The current index that the ScrollablePositionedList is on.
  int _currentIndex = 0;

  /// Add an index to the root index.
  void addToRootIndexes(int addedIndex) {
    rootIndexes.add(addedIndex);
    notifyListeners();
  }

  /// Sets the root indexes list.
  ///
  /// Should be carefully used. This could mess up the order of indexes.
  void setRootIndexes(List<int> rootIndexes) {
    _rootIndexes = rootIndexes;
    notifyListeners();
  }

  /// Clears the root indexes.
  void clearRootIndexes() {
    rootIndexes.clear();
    notifyListeners();
  }

  /// Clears the comments.
  void clearComments() {
    comments!.clear();
    notifyListeners();
  }

  /// Refreshes the list of comments.
  Future<void> refresh(
      {RefreshType refreshType = RefreshType.programmatically}) async {
    await _itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    _isDoingRefreshAnim = true;
    clearRootIndexes();
    if (refreshType == RefreshType.programmatically &&
        _refreshIndicatorKey.currentState!.controller.isIdle) {
      HapticFeedback.lightImpact();
      await _refreshIndicatorKey.currentState?.show(
          draggingDuration: const Duration(milliseconds: 200),
          draggingCurve: Curves.easeInOutCubic);
      await onRefresh!();
      await Future.delayed(const Duration(milliseconds: 800));
      await _refreshIndicatorKey.currentState?.hide();
    } else if (refreshType == RefreshType.manual) {
      HapticFeedback.lightImpact();
      await onRefresh!();
      await Future.delayed(const Duration(milliseconds: 400));
    }
    _isDoingRefreshAnim = false;
    // notifyListeners();
  }

  /// Scrolls to the top of the list of comments.
  void scrollToTop() {
    if (_isDoingRefreshAnim) return;
    _itemScrollController.scrollTo(
      alignment:
          1.1, // This algnment property helps the two nested scroll views play nice (goes to top, and then a *tiny* bit more, as
      //  to trigger the next scroll view, so it is ready to be swiped to refresh).
      index: 0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Scrolls down to the closest root comment.
  void scrollDownToRoot() {
    if (_itemPositionsListener.itemPositions.value.isEmpty ||
        _isDoingRefreshAnim) return;
    int? result =
        rootIndexes.firstWhereOrNull((element) => element > _currentIndex);
    if (result != null) {
      _itemScrollController.scrollTo(
        index: result,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Scrolls up to the closest root comment.
  void scrollUpToRoot() {
    if (_itemPositionsListener.itemPositions.value.isEmpty ||
        _isDoingRefreshAnim) {
      return;
    }
    int? result = _rootIndexes.reversed
        .firstWhereOrNull((element) => element < _currentIndex);
    if (result != null) {
      _itemScrollController.scrollTo(
        index: result,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _itemScrollController.scrollTo(
        index: 0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

/// Types of refreshes that can occur.
enum RefreshType {
  programmatically,
  manual,
}

class InfiniteCommentThread<T> extends StatefulWidget {
  InfiniteCommentThread({
    required this.loadMore,
    required this.refreshScreen,
    required this.header,
    required this.comment,
    required this.comments,
    this.onTopChange,
    this.preloadBy = 5,
    required this.controller,
    Key? key,
  }) : super(key: key) {
    controller.comments = comments;
    controller.onRefresh = refreshScreen;
  }

  final Future<void> Function() loadMore;
  final Future<void> Function() refreshScreen;
  final List<T> comments;
  final Widget header;

  /// Passes an [index] field that the comment is inside the list.
  ///
  ///
  /// To check stats like, "is root?", do this:
  ///
  /// <YOUR_LIST_OF_COMMENTS>[index - 1].<CHECK_IF_ROOT>
  ///
  /// Example: comments[index - 1].isRoot
  ///
  /// It's recommended to use a function to create this comment like so:
  ///
  /// Widget buildComment(int index) {
  ///   return Container(
  ///     padding: const EdgeInsets.symmetric(vertical: 15),
  ///     margin: const EdgeInsets.symmetric(vertical: 5),
  ///     color: Colors.lightBlueAccent,
  ///     child: Text('Comment: ${comments[index - 1].isRoot}'),
  ///   );
  /// }
  final Widget Function(int index) comment;
  final int preloadBy;
  final InfiniteCommentThreadController<T> controller;
  final Function(bool atTop)? onTopChange;

  @override
  State<InfiniteCommentThread> createState() => _InfiniteCommentThreadState();
}

class _InfiniteCommentThreadState extends State<InfiniteCommentThread> {
  // If more comments are currently being loaded.
  bool isLoadingMore = false;

  /// Adds listeners to the [ScrollablePositionedList] to manage:
  ///
  /// - Setting/updating the current index of the list.
  /// - Checking whether it's time to preload more comments.
  /// - Checking if the scrollable list is at the very top or not.
  @override
  void initState() {
    widget.controller._itemPositionsListener.itemPositions
        .addListener(() async {
      // Setting the current index of the ScrollablePositionedList.
      widget.controller._currentIndex = widget
          .controller._itemPositionsListener.itemPositions.value
          .toList()
          .reduce((curr, next) => curr.index < next.index ? curr : next)
          .index;
      if (mounted) {
        setState(() {});
      }
      // Checking when to preload more comments.
      final indicies = widget
          .controller._itemPositionsListener.itemPositions.value
          .map((post) => post.index);
      if (indicies.toList().last + widget.preloadBy >=
              widget.controller.comments!.length &&
          isLoadingMore == false) {
        isLoadingMore = true;
        await widget.loadMore();
        isLoadingMore = false;
      }
      // Checking if scrollable list is at the top or not.
      if (widget.controller._itemPositionsListener.itemPositions.value
              .isNotEmpty &&
          widget.controller._itemPositionsListener.itemPositions.value.first
                  .itemLeadingEdge ==
              0 &&
          widget.controller._itemPositionsListener.itemPositions.value
                  .toList()
                  .reduce((curr, next) => curr.index < next.index ? curr : next)
                  .index ==
              0) {
        widget.onTopChange!(true);
      } else {
        widget.onTopChange!(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      key: widget.controller._refreshIndicatorKey,
      onRefresh: () async =>
          await widget.controller.refresh(refreshType: RefreshType.manual),
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Stack(
              clipBehavior: Clip.hardEdge,
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
        absorbing: widget.controller._isDoingRefreshAnim,
        child: ScrollablePositionedList.builder(
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: widget.controller.comments!.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return widget.header;
            } else {
              return widget.comment(index);
            }
          },
          itemScrollController: widget.controller._itemScrollController,
          itemPositionsListener: widget.controller._itemPositionsListener,
        ),
      ),
    );
  }
}
