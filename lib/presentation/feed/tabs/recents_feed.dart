import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/feed/widgets/simple_post_tile.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    feedListController.dispose();
    super.dispose();
  }

  Future<void> loadMorePost() async {
    await Future.delayed(const Duration(milliseconds: 500));
    feedListController.addItems(const [
      SimplePostTile(),
      SimplePostTile(),
      SimplePostTile(),
      SimplePostTile(),
      SimplePostTile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      child: Column(
        children: [
          // Row(
          //   children: [
          //     TextButton(onPressed: () => feedListController.addItem(const SimplePostTile()), child: Text("add item")),
          //     TextButton(onPressed: () => feedListController.scrollToTop(), child: Text("to top")),
          //     TextButton(onPressed: () => feedListController.clearList(), child: Text("clear")),
          //     TextButton(onPressed: () => showCreateAccountSheet(context), child: Text("create account")),
          //   ],
          // ),
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
              header: Container(
                margin: const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Check out the newest updates, news, and give feedback to the developers.",
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              controller: feedListController,
            ),
          ),
        ],
      ),
    );
  }
}
