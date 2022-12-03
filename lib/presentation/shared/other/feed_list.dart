import 'package:Confessi/presentation/authentication_and_settings/widgets/settings/theme_sample_circle.dart';
import 'package:Confessi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum FeedIndicatorWidget {
  error,
  loading,
  atEnd,
}

class FeedListController extends ChangeNotifier {
  // How many items to preload the feed by.
  final int preloadBy;

  FeedListController({this.preloadBy = 5});

  // Items to be in the feed.
  List<Widget> items = [];
  // Controller 1 for [ScrollablePositionedList].
  final ItemScrollController itemScrollController = ItemScrollController();

  // Controller 2 for [ScrollablePositionedList].
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  /// Adds an item to the list.
  void addItem(Widget item) {
    items.add(item);
    notifyListeners();
  }

  /// Scrolls to the top of the list (over a set duration).
  void scrollToTop() {
    itemScrollController.scrollTo(index: 0, duration: const Duration(milliseconds: 150));
  }

  /// Clears the list.
  void clearList() {
    items.clear();
    notifyListeners();
  }
}

class FeedList extends StatefulWidget {
  const FeedList({
    super.key,
    this.header,
    required this.controller,
    required this.onPreload,
    required this.onPullToRefresh,
    required this.feedIndicatorWidget,
  });

  final FeedIndicatorWidget feedIndicatorWidget;
  final Widget? header;
  final FeedListController controller;
  final VoidCallback onPreload;
  final Function onPullToRefresh;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  void initState() {
    widget.controller.itemPositionsListener.itemPositions.addListener(() {
      List<int> visibleIndexes =
          widget.controller.itemPositionsListener.itemPositions.value.map((item) => item.index).toList();
      if (widget.controller.items.length - visibleIndexes.last < widget.controller.preloadBy) {
        widget.onPreload();
      }
    });
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  Widget buildIndicator(FeedIndicatorWidget feedIndicatorWidget) {
    switch (feedIndicatorWidget) {
      case FeedIndicatorWidget.error:
        return const Text("error");
      case FeedIndicatorWidget.atEnd:
        return const Text("at end");
      case FeedIndicatorWidget.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: CupertinoActivityIndicator(),
        );
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
            return buildIndicator(widget.feedIndicatorWidget);
          } else if (widget.controller.items.isNotEmpty) {
            return widget.controller.items[index - 1];
          } else {
            return Container();
          }
        },
        itemCount: widget.controller.items.length + 2,
        itemPositionsListener: widget.controller.itemPositionsListener,
        itemScrollController: widget.controller.itemScrollController,
      ),
    );
  }
}
