import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/domain/profile/entities/number_of_each_achievement_type.dart';
import 'package:Confessi/presentation/profile/widgets/achievement_stat_tile.dart';
import 'package:Confessi/presentation/profile/widgets/like_hate_hottest_pageview_tile.dart';
import 'package:Confessi/presentation/shared/buttons/pop.dart';
import 'package:Confessi/presentation/shared/stat_tiles/stat_tile_group.dart';
import 'package:Confessi/presentation/shared/stat_tiles/stat_tile_item.dart';
import 'package:flutter/cupertino.dart';

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
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
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
                                const SizedBox(height: 30),
                                PopButton(
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  textColor: Theme.of(context).colorScheme.primary,
                                  text: state.universityFullName,
                                  onPress: () => print("tap"),
                                  icon: CupertinoIcons.pen,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            border: Border(
                              bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                            ),
                          ),
                          child: Row(
                            children: [
                              StatTileItem(
                                color: Theme.of(context).colorScheme.primary,
                                text: "Confessions",
                                icon: CupertinoIcons.cube_box,
                                onTap: () => Navigator.pushNamed(context, "/home/profile/posts"),
                              ),
                              StatTileItem(
                                color: Theme.of(context).colorScheme.primary,
                                text: "Saved",
                                icon: CupertinoIcons.bookmark,
                                onTap: () => Navigator.pushNamed(context, "/home/profile/saved"),
                              ),
                              StatTileItem(
                                color: Theme.of(context).colorScheme.primary,
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
                            onNotification: (_) => true,
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
                                  pluralHeader: "dislike",
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
