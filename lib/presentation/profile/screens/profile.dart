import 'package:Confessi/presentation/profile/screens/profile_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/top_tabs.dart';

// TODO: Remove the crossing of layers - maybe move the authentication cubit to core?

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    tabController = TabController(vsync: this, length: 2, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CupertinoScrollbar(
        controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.green,
                height: 100,
                child: Text("header"),
              ),
            ),
            SliverStickyHeader(
              header: TopTabs(
                tabController: tabController,
                tabs: const [
                  Tab(text: "tab1"),
                  Tab(text: "tab2"),
                ],
              ),
              sliver: SliverToBoxAdapter(
                  // hasScrollBody: false,
                  child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: 1000,
                  // height: double.maxFinite,
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          physics: const ClampingScrollPhysics(),
                          controller: tabController,
                          dragStartBehavior: DragStartBehavior.down,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, i) => Text(
                                "item $i",
                                style: TextStyle(fontSize: 40),
                              ),
                              itemCount: 15,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, i) => Text(
                                "item $i",
                                style: TextStyle(fontSize: 40),
                              ),
                              itemCount: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
            ),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     childCount: 3,
            //     (context, index) {
            //       if (index == 0) {
            //         return Container(height: 200, color: Colors.blue);
            //       } else if (index == 1) {
            //         return null;
            //       } else {
            //         return SizedBox(
            //           height: 1200,
            //           child: TabBarView(
            //             physics: const ClampingScrollPhysics(),
            //             controller: tabController,
            //             dragStartBehavior: DragStartBehavior.down,
            //             children: [
            //               Container(color: Colors.blue, height: 1200),
            //               Container(color: Colors.green, height: 1200),
            //             ],
            //           ),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
