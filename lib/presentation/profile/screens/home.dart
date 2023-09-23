import 'package:confesi/constants/shared/constants.dart';

import '../../../core/router/go_router.dart';

import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/stat_tiles/stat_tile_item.dart';
import 'package:flutter/cupertino.dart';

import 'package:scrollable/exports.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/other/cached_online_image.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/simple_text.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({
    super.key,
  });

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        top: false,
        child: ThemeStatusBar(
          child: ScrollableView(
            physics: const BouncingScrollPhysics(),
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: heightFraction(context, .4),
                  width: double.infinity,
                  child: const CachedOnlineImage(
                      url: "https://www.uvic.ca/_assets/images/cards/overlay/climate-solutions-3600-1450.jpg"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: SimpleTextButton(
                    infiniteWidth: true,
                    bgColor: Theme.of(context).colorScheme.background,
                    textColor: Theme.of(context).colorScheme.primary,
                    text: "Edit account details",
                    onTap: () => router.push("/home/profile/account"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).colorScheme.background,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: borderSize,
                        strokeAlign: BorderSide.strokeAlignInside),
                  ),
                  child: Row(
                    children: [
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Your confessions",
                        icon: CupertinoIcons.cube_box,
                        onTap: () => router.push("/home/profile/posts"),
                      ),
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Your comments",
                        icon: CupertinoIcons.chat_bubble,
                        onTap: () => router.push("/home/profile/comments"),
                      ),
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Saved confessions",
                        icon: CupertinoIcons.bookmark,
                        onTap: () => router.push('/home/profile/saved/posts'),
                      ),
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Saved comments",
                        icon: CupertinoIcons.bookmark,
                        onTap: () => router.push("/home/profile/saved/comments"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
