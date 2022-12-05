import 'package:Confessi/presentation/shared/other/feed_list.dart';
import 'package:Confessi/presentation/shared/overlays/create_account_sheet.dart';
import 'package:flutter/material.dart';

class ExploreRecents extends StatefulWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  State<ExploreRecents> createState() => _ExploreRecentsState();
}

class _ExploreRecentsState extends State<ExploreRecents> {
  late FeedListController feedListController;

  @override
  void initState() {
    feedListController = FeedListController();
    feedListController.addItems(const [Text("HEY"), Text("HEY")]);
    feedListController.addItem(const Text("HEY"));
    super.initState();
  }

  @override
  void dispose() {
    feedListController.dispose();
    super.dispose();
  }

  Future<void> loadMorePost() async {
    await Future.delayed(const Duration(milliseconds: 500));
    feedListController.addItems([
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        height: 100,
        width: double.infinity,
        child: const Text("ITEM"),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        height: 100,
        width: double.infinity,
        child: const Text("ITEM"),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        height: 100,
        width: double.infinity,
        child: const Text("ITEM"),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        height: 100,
        width: double.infinity,
        child: const Text("ITEM"),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        height: 100,
        width: double.infinity,
        child: const Text("ITEM"),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () => feedListController.addItem(
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Colors.redAccent,
                          height: 100,
                          width: double.infinity,
                          child: const Text("ITEM"),
                        ),
                      ),
                  child: Text("add item")),
              TextButton(onPressed: () => feedListController.scrollToTop(), child: Text("to top")),
              TextButton(onPressed: () => feedListController.clearList(), child: Text("clear")),
              TextButton(onPressed: () => showCreateAccountSheet(context), child: Text("create account")),
            ],
          ),
          Expanded(
            child: FeedList(
              hasError: false,
              hasReachedEnd: false,
              onEndOfFeedReachedButtonPressed: () async => await loadMorePost(),
              onErrorButtonPressed: () async => await loadMorePost(),
              onPullToRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 1000));
                feedListController.clearList();
              },
              loadMore: () async => await loadMorePost(),
              header: Container(color: Colors.green, height: 100, width: double.infinity, child: const Text("HEADER")),
              controller: feedListController,
            ),
          ),
        ],
      ),
    );
  }
}
