import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/domain/profile/entities/number_of_each_achievement_type.dart';
import 'package:Confessi/core/alt_unused/achievement_stat_tile.dart';
import 'package:Confessi/presentation/profile/widgets/like_hate_hottest_pageview_tile.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:Confessi/presentation/shared/buttons/pop.dart';
import 'package:Confessi/presentation/shared/stat_tiles/stat_tile_group.dart';
import 'package:Confessi/presentation/shared/stat_tiles/stat_tile_item.dart';
import 'package:flutter/cupertino.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../application/profile/cubit/profile_cubit.dart';
import '../../../application/shared/cubit/share_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../../core/utils/sizing/top_safe_area.dart';
import '../../../domain/profile/entities/achievement_tile_entity.dart';
import '../../primary/controllers/profile_controller.dart';
import '../../shared/indicators/alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/edited_source_widgets/swipe_refresh.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/other/cached_online_image.dart';
import '../../shared/overlays/info_sheet_with_action.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/buttons/simple_text.dart';
import '../widgets/achievement_rarity_numbers_display_tile.dart';
import '../widgets/stat_tile.dart';

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

  void shareStatContent(
      BuildContext context, int value, double percentage, String valueTypeSingular, String valueTypePlural) {
    context.read<ShareCubit>().shareContent(
          context,
          "I have ${addCommasToNumber(value)} ${isPlural(value) ? valueTypePlural : valueTypeSingular}, putting me in the top $percentage% of users!",
          "Check out my $valueTypePlural!",
        );
  }

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

  double scrollDy = 0.0;

  NumberOfEachAchievementType numberOfEachRarityForAchievements(List<AchievementTileEntity> achievements) {
    NumberOfEachAchievementType numberOfEachAchievementType = NumberOfEachAchievementType();
    for (AchievementTileEntity achievement in achievements) {
      switch (achievement.rarity) {
        case AchievementRarity.common:
          numberOfEachAchievementType.addCommmon(achievement.quantity);
          break;
        case AchievementRarity.rare:
          numberOfEachAchievementType.addRare(achievement.quantity);
          break;
        case AchievementRarity.epic:
          numberOfEachAchievementType.addEpic(achievement.quantity);
          break;
        case AchievementRarity.legendary:
          numberOfEachAchievementType.addLegendary(achievement.quantity);
          break;
      }
    }
    return numberOfEachAchievementType;
  }

  Widget buildLoadedScreen(BuildContext context, ProfileData state) => ThemedStatusBar(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (details) {
            if (details.metrics.pixels <= 0) {
              setState(() {
                scrollDy = details.metrics.pixels.abs();
              });
            }
            return false;
          },
          child: SwipeRefresh(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.background,
            onRefresh: () async => await context.read<ProfileCubit>().reloadProfile(),
            child: ScrollableView(
              hapticsEnabled: false,
              scrollBarVisible: false,
              controller: widget.profileController.scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(scrollDy),
                              topRight: Radius.circular(scrollDy),
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: Column(
                              children: [
                                Container(
                                  width: widthFraction(context, 1 / 2),
                                  height: widthFraction(context, 1 / 2),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                                        blurRadius: 30,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Theme.of(context).colorScheme.background, width: 2),
                                  ),
                                  child: CachedOnlineImage(url: state.universityImgUrl, isCircle: true),
                                ),
                                // const SizedBox(height: 30),
                                // PopButton(
                                //   backgroundColor: Theme.of(context).colorScheme.background,
                                //   textColor: Theme.of(context).colorScheme.primary,
                                //   text: state.universityFullName,
                                //   onPress: () => print("tap"),
                                //   icon: CupertinoIcons.pen,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        TouchableScale(
                          onTap: () => Navigator.pushNamed(context, "/profile/account_details"),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
                              color: Theme.of(context).colorScheme.background,
                              border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Edit Account Details",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.arrow_right,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            ),
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
                        Container(
                          color: Theme.of(context).colorScheme.shadow,
                          height: 200,
                          child: NotificationListener<ScrollUpdateNotification>(
                            onNotification: (_) => true, // Don't bubble scroll notifications
                            child: PageView(
                              controller: pageController,
                              children: [
                                LikeHateHottestPageviewTile(
                                  header: "like",
                                  percentile: state.statTileEntity.topLikesPercentage,
                                  pluralHeader: "likes",
                                  value: state.statTileEntity.totalLikes,
                                ),
                                LikeHateHottestPageviewTile(
                                  header: "dislikes",
                                  percentile: state.statTileEntity.topDislikesPercentage,
                                  pluralHeader: "dislikes",
                                  value: state.statTileEntity.totalDislikes,
                                ),
                                LikeHateHottestPageviewTile(
                                  header: "hottest",
                                  percentile: state.statTileEntity.topHottestsPercentage,
                                  pluralHeader: "hottests",
                                  value: state.statTileEntity.totalHottests,
                                  showSwipeSign: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AchievementRarityNumbersDisplayTile(
                          onTapCommons: () => Navigator.pushNamed(context, "/profile/achievements"),
                          onTapRares: () => Navigator.pushNamed(context, "/profile/achievements"),
                          onTapEpics: () => Navigator.pushNamed(context, "/profile/achievements"),
                          onTapLegendaries: () => Navigator.pushNamed(context, "/profile/achievements"),
                          numOfCommons: numberOfEachRarityForAchievements(state.achievementTileEntities).commons,
                          numOfRares: numberOfEachRarityForAchievements(state.achievementTileEntities).rares,
                          numOfEpics: numberOfEachRarityForAchievements(state.achievementTileEntities).epics,
                          numOfLegendaries:
                              numberOfEachRarityForAchievements(state.achievementTileEntities).legendaries,
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

  Widget buildChildFromState(ProfileState state) {
    if (state is ProfileLoading) {
      return Center(
        key: const ValueKey('loading'),
        child: Padding(
          padding: EdgeInsets.only(top: topSafeArea(context)),
          child: const LoadingCupertinoIndicator(),
        ),
      );
    } else if (state is ProfileData) {
      return buildLoadedScreen(context, state);
    } else {
      return Center(
        key: const ValueKey('error'),
        child: Padding(
          padding: EdgeInsets.only(top: topSafeArea(context)),
          child: AlertIndicator(
            message: state is! ProfileError ? "Unknown error." : state.message,
            onPress: () => context.read<ProfileCubit>().loadProfile(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        top: false,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: buildChildFromState(state),
            );
          },
        ),
      ),
    );
  }
}
