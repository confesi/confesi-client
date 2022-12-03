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
    feedListController.addItem(Text("HEY"));
    feedListController.addItem(Text("HEY"));

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
              TextButton(onPressed: () => feedListController.addItem(Text("added")), child: Text("add item")),
              TextButton(onPressed: () => feedListController.scrollToTop(), child: Text("to top")),
              TextButton(onPressed: () => feedListController.clearList(), child: Text("clear")),
            ],
          ),
          Expanded(
            child: FeedList(
              header: Container(color: Colors.green, height: 100, width: double.infinity, child: const Text("HEADER")),
              controller: feedListController,
            ),
          ),
        ],
      ),
    );
  }
}
