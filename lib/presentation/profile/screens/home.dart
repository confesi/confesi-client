import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/stat_tiles/stat_tile_item.dart';
import 'package:flutter/cupertino.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../primary/controllers/profile_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/other/cached_online_image.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/simple_text.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({
    super.key,
    required this.profileController,
  });

  final ProfileController profileController;

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        top: false,
        child: ThemedStatusBar(
          child: ScrollableView(
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
                    onTap: () => Navigator.pushNamed(context, "/profile/account_details"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
                    color: Theme.of(context).colorScheme.background,
                    border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Confessions",
                        icon: CupertinoIcons.cube_box,
                        onTap: () => Navigator.pushNamed(context, "/home/profile/posts"),
                      ),
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Saved",
                        icon: CupertinoIcons.bookmark,
                        onTap: () => Navigator.pushNamed(context, "/home/profile/saved"),
                      ),
                      StatTileItem(
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        text: "Comments",
                        icon: CupertinoIcons.chat_bubble,
                        onTap: () => Navigator.pushNamed(context, "/home/profile/comments"),
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
