import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/authentication/widgets/scroll_dots.dart';
import 'package:Confessi/presentation/profile/screens/comments_tab.dart';
import 'package:Confessi/presentation/profile/screens/posts_tab.dart';
import 'package:Confessi/presentation/profile/screens/profile_tab.dart';
import 'package:Confessi/presentation/profile/widgets/animated_scroll_dots.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/top_tabs.dart';

// TODO: Remove the crossing of layers - maybe move the authentication cubit to core?

class TabsManager extends StatefulWidget {
  const TabsManager({super.key});

  @override
  State<TabsManager> createState() => _TabsManagerState();
}

class _TabsManagerState extends State<TabsManager>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late ScrollController scrollController;

  int tabIndex = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        tabIndex = (pageController.offset / widthFraction(context, 1)).round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView(
            controller: pageController,
            children: const [
              ProfileTab(),
              PostsTab(),
              CommentsTab(),
            ],
          ),
          AnimatedScrollDots(
            pageLength: 3,
            pageIndex: tabIndex,
            verticalPadding: 15,
          ),
        ],
      ),
    );
  }
}
