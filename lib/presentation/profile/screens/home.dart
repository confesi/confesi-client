import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/domain/profile/entities/number_of_each_achievement_type.dart';
import 'package:Confessi/presentation/profile/widgets/achievement_stat_tile.dart';

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
            onRefresh: () async => await context.read<ProfileCubit>().reloadProfile(),
            child: ScrollableView(
              inlineBottomOrRightPadding: 15,
              hapticsEnabled: false,
              scrollBarVisible: false,
              controller: widget.profileController.scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(scrollDy), topRight: Radius.circular(scrollDy)),
                    child: SizedBox(
                      height: heightFraction(context, 2 / 5),
                      width: double.infinity,
                      child: CachedOnlineImage(url: state.universityImgUrl),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "@dougtheuser",
                              style: kTitle.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Private profile only visible to you.",
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: SimpleTextButton(
                                bgColor: Theme.of(context).colorScheme.background,
                                onTap: () => Navigator.pushNamed(context, '/home/profile/comments'),
                                text: "Comments",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SimpleTextButton(
                                bgColor: Theme.of(context).colorScheme.background,
                                onTap: () => Navigator.pushNamed(context, '/home/profile/posts'),
                                text: "Confessions",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SimpleTextButton(
                          bgColor: Theme.of(context).colorScheme.background,
                          infiniteWidth: true,
                          onTap: () => Navigator.pushNamed(context, '/home/profile/saved'),
                          text: "Saved Confessions",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          "Statistics",
                          style: kDisplay1.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: StatTile(
                          leftTap: () => showInfoSheetWithAction(
                            context,
                            "${addCommasToNumber(state.statTileEntity.totalLikes)} total ${isPlural(state.statTileEntity.totalLikes) ? "likes" : "like"}. Top ${state.statTileEntity.topLikesPercentage}% of users.",
                            "Yup, everyone loves your content.",
                            () => shareStatContent(context, state.statTileEntity.totalLikes,
                                state.statTileEntity.topLikesPercentage, "like", "likes"),
                            "Share with friends",
                          ),
                          centerTap: () => showInfoSheetWithAction(
                            context,
                            "${addCommasToNumber(state.statTileEntity.totalHottests)} total ${isPlural(state.statTileEntity.totalHottests) ? "hottests" : "hottest"}. Top ${state.statTileEntity.topHottestsPercentage}% of users.",
                            "Oh so popular, huh?",
                            () => shareStatContent(context, state.statTileEntity.totalHottests,
                                state.statTileEntity.topHottestsPercentage, "hottest", "hottests"),
                            "Share with friends",
                          ),
                          rightTap: () => showInfoSheetWithAction(
                            context,
                            "${addCommasToNumber(state.statTileEntity.totalDislikes)} total ${isPlural(state.statTileEntity.totalDislikes) ? "hates" : "hate"}. Top ${state.statTileEntity.topDislikesPercentage}% of users.",
                            "It's confirmed. You're a baddie.",
                            () => shareStatContent(context, state.statTileEntity.totalDislikes,
                                state.statTileEntity.topDislikesPercentage, "hate", "hates"),
                            "Share with friends",
                          ),
                          leftNumber: state.statTileEntity.totalLikes,
                          leftDescription: "Likes",
                          centerNumber: state.statTileEntity.totalHottests,
                          centerDescription: "Hottests",
                          rightNumber: state.statTileEntity.totalDislikes,
                          rightDescription: "Hates",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          "Achievements",
                          style: kDisplay1.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AchievementStatTile(
                          numOfCommons: numberOfEachRarityForAchievements(state.achievementTileEntities).commons,
                          numOfRares: numberOfEachRarityForAchievements(state.achievementTileEntities).rares,
                          numOfEpics: numberOfEachRarityForAchievements(state.achievementTileEntities).epics,
                          numOfLegendaries:
                              numberOfEachRarityForAchievements(state.achievementTileEntities).legendaries,
                        ),
                      ),
                    ],
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
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: buildChildFromState(state),
          );
        },
      ),
    );
  }
}
