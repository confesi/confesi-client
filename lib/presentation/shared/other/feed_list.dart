import 'package:Confessi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FeedListController extends ChangeNotifier {
  // Items to be in the feed.
  List<Widget> items = [];
  // Controller 1 for [ScrollablePositionedList].
  final ItemScrollController itemScrollController = ItemScrollController();

  // Controller 2 for [ScrollablePositionedList].
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  // Adds an item to the list.
  void addItem(Widget item) {
    items.add(item);
    notifyListeners();
  }

  // Scrolls to the top of the list (over a set duration).
  void scrollToTop() {
    itemScrollController.scrollTo(index: 0, duration: const Duration(milliseconds: 150));
  }

  // Clears the list.
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
  });

  final Widget? header;
  final FeedListController controller;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  void initState() {
    widget.controller.itemPositionsListener.itemPositions.addListener(() {
      print("listener");
    });
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeRefresh(
      onRefresh: () async => await Future.delayed(const Duration(milliseconds: 750)),
      child: ScrollablePositionedList.builder(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 0),
              child: widget.header ?? Container(),
            );
          } else if (index == widget.controller.items.length + 1) {
            return Container(color: Colors.blueAccent, height: 100, width: 100);
          } else {
            return Container(color: Colors.pink, height: 100, width: 100);
          }
        },
        itemCount: widget.controller.items.length + 2,
        itemPositionsListener: widget.controller.itemPositionsListener,
        itemScrollController: widget.controller.itemScrollController,
      ),
    );
  }
}
