// TODO: outdated; old style, complex ui

import 'package:flutter/cupertino.dart';


class ExploreTrending extends StatefulWidget {
  const ExploreTrending({Key? key}) : super(key: key);

  @override
  State<ExploreTrending> createState() => _ExploreTrendingState();
}

class _ExploreTrendingState extends State<ExploreTrending> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return const Text("todo");
  }

  @override
  bool get wantKeepAlive => true;
}
