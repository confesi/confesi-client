import '../../shared/overlays/info_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/layout/top_tabs.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                bottomBorder: false,
                centerWidget: Text(
                  "Saved Content",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TopTabs(
                      tabController: tabController,
                      tabs: [
                        Tab(
                          child: Text(
                            "Confessions",
                            style: kDetail.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Comments",
                            style: kDetail.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.shadow,
                        child: TabBarView(
                          physics: const ClampingScrollPhysics(),
                          controller: tabController,
                          dragStartBehavior: DragStartBehavior.down,
                          children: [
                            Container(),
                            Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
