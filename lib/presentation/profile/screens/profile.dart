import 'package:Confessi/core/utils/sizing/height_breakpoint_fraction.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/profile/screens/profile_tab.dart';
import 'package:Confessi/presentation/profile/widgets/flexible_appbar.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/buttons/animated_simple_text.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/styles/typography.dart';
import '../../authentication/cubit/authentication_cubit.dart';
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
    tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  double scrollExtentBefore = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          setState(() {
            scrollExtentBefore = notification.metrics.extentBefore;
          });
          return true;
        },
        child: CupertinoScrollbar(
          controller: scrollController,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0.0,
                backgroundColor: Theme.of(context).colorScheme.background,
                automaticallyImplyLeading: false,
                expandedHeight: heightBreakpointFraction(context, 0.5, 300),
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(0),
                  expandedTitleScale: 1,
                  title: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Opacity(
                              opacity: 1 - scrollExtentBefore / 175 < 0
                                  ? 0
                                  : 1 - scrollExtentBefore / 175,
                              child: const FlexibleAppbar(),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TopTabs(
                              tabController: tabController,
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Profile",
                                    style: kDetail.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Posts",
                                    style: kDetail.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Comments",
                                    style: kDetail.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IgnorePointer(
                        ignoring: (1 - scrollExtentBefore / 175 < 0
                                    ? 0
                                    : 1 - scrollExtentBefore / 175) <
                                .5
                            ? true
                            : false,
                        child: Opacity(
                          opacity: 1 - scrollExtentBefore / 175 < 0
                              ? 0
                              : 1 - scrollExtentBefore / 175,
                          child: TouchableOpacity(
                            onTap: () => print("TAP"),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  // Transparent hitbox trick.
                                  color: Colors.transparent,
                                  child: Transform.scale(
                                    scale: 1 - scrollExtentBefore / 175 < 0
                                        ? 0
                                        : 1 - scrollExtentBefore / 175,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.gear,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Settings",
                                          style: kDetail.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (_) => true,
                child: SliverFillRemaining(
                  fillOverscroll: true,
                  child: Container(
                    color: Theme.of(context).colorScheme.onError,
                    child: TabBarView(
                      physics: const ClampingScrollPhysics(),
                      controller: tabController,
                      dragStartBehavior: DragStartBehavior.down,
                      children: const [
                        ProfileTab(),
                        ProfileTab(),
                        ProfileTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
