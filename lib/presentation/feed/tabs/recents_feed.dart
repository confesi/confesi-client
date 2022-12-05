import 'package:Confessi/presentation/shared/indicators/alert.dart';
import 'package:Confessi/presentation/shared/other/feed_list.dart';
import 'package:flutter/cupertino.dart';
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
            ],
          ),
          Expanded(
            child: FeedList(
              hasError: false,
              hasReachedEnd: false,
              onPullToRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 1000));
                feedListController.clearList();
              },
              loadMore: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                feedListController.addItem(
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: Colors.redAccent,
                    height: 100,
                    width: double.infinity,
                    child: const Text("ITEM"),
                  ),
                );
              },
              header: Container(color: Colors.green, height: 100, width: double.infinity, child: const Text("HEADER")),
              controller: feedListController,
            ),
          ),
        ],
      ),
    );
  }
}
