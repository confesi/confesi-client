import 'package:Confessi/application/profile/cubit/profile_cubit.dart';
import 'package:Confessi/application/shared/cubit/share_cubit.dart';
import 'package:Confessi/core/utils/numbers/is_plural.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/presentation/primary/controllers/profile_controller.dart';
import 'package:Confessi/presentation/profile/widgets/achievement_builder.dart';
import 'package:Confessi/presentation/shared/indicators/alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/edited_source_widgets/swipe_refresh.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/other/cached_online_image.dart';
import '../../shared/overlays/info_sheet_with_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/buttons/emblem.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/text/group.dart';
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

  Widget buildLoadedScreen(BuildContext context, ProfileData state) => ThemedStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SwipeRefresh(
            onRefresh: () async => await context.read<ProfileCubit>().reloadProfile(),
            child: ScrollableView(
              hapticsEnabled: false,
              scrollBarVisible: false,
              controller: widget.profileController.scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SizedBox(
                      height: heightFraction(context, 1 / 3),
                      width: double.infinity,
                      child: CachedOnlineImage(url: state.universityImgUrl),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: GroupText(
                                leftAlign: true,
                                small: true,
                                header: state.username,
                                body: "${state.universityFullName} (${state.universityAbbr})",
                              ),
                            ),
                            const SizedBox(width: 5),
                            EmblemButton(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              icon: CupertinoIcons.lock,
                              onPress: () => showInfoSheetWithAction(
                                context,
                                "This profile is private",
                                "This profile is only visible to you. In fact, to add an extra layer of protection, you can enable biometric authentication to keep your saved posts, confessions, and comments locked.",
                                () => Navigator.pushNamed(context, "/settings/biometric_lock"),
                                "Edit biometric lock settings",
                              ),
                              iconColor: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: StatTile(
                              leftTap: () => showInfoSheetWithAction(
                                context,
                                "Total likes",
                                "${addCommasToNumber(state.statTileEntity.totalLikes)} / Top ${state.statTileEntity.topLikesPercentage}% of users",
                                () => shareStatContent(context, state.statTileEntity.totalLikes,
                                    state.statTileEntity.topLikesPercentage, "like", "likes"),
                                "Share with friends",
                              ),
                              centerTap: () => showInfoSheetWithAction(
                                context,
                                "Total hottests",
                                "${addCommasToNumber(state.statTileEntity.totalHottests)} / Top ${state.statTileEntity.topHottestsPercentage}% of users",
                                () => shareStatContent(context, state.statTileEntity.totalHottests,
                                    state.statTileEntity.topHottestsPercentage, "hottest", "hottests"),
                                "Share with friends",
                              ),
                              rightTap: () => showInfoSheetWithAction(
                                context,
                                "Total hates",
                                "${addCommasToNumber(state.statTileEntity.totalDislikes)} / Top ${state.statTileEntity.topDislikesPercentage}% of users",
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
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SimpleTextButton(
                                    onTap: () => Navigator.pushNamed(context, '/home/profile/comments'),
                                    text: "Comments",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SimpleTextButton(
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
                              infiniteWidth: true,
                              onTap: () => Navigator.pushNamed(context, '/home/profile/saved'),
                              text: "Saved Confessions",
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: AchievementBuilder(achievements: state.achievementTileEntities),
                          ),
                          const SizedBox(height: 20),
                        ],
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: buildChildFromState(state),
        );
      },
    );
  }
}
