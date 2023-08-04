import 'package:confesi/models/post.dart';
import 'package:flutter/material.dart';

import '../../../domain/shared/entities/infinite_scroll_indexable.dart';
import '../../shared/other/feed_list.dart';
import '../widgets/post_tile.dart';

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
    feedListController.addItems([
      // todo: feed
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
          // const IconWithIndicator(icon: CupertinoIcons.bell),
          // Expanded(
          //   child: FeedList(
          //     hasError: false,
          //     wontLoadMore: false,
          //     onWontLoadMoreButtonPressed: () async => await loadMorePost(),
          //     onErrorButtonPressed: () async => await loadMorePost(),
          //     onPullToRefresh: () async {
          //       await Future.delayed(const Duration(milliseconds: 1000));
          //       feedListController.clearList();
          //     },
          //     wontLoadMoreMessage: "todo: wont load more",
          //     loadMore: (id) async {
          //       print("LAST SEEN ID: $id");
          //       await loadMorePost();
          //     },
          //     controller: feedListController,
          //   ),
          // ),
        ],
      ),
    );
  }
}
