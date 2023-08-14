import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/services/primary_tab_service/primary_tab_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/other/zoomable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/feed/cubit/schools_drawer_cubit.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../core/services/posts_service/posts_service.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../../init.dart';
import '../../shared/buttons/circle_icon_btn.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/other/cached_online_image.dart';

class SchoolDetail extends StatelessWidget {
  const SchoolDetail({super.key, required this.props});

  final HomeLeaderboardSchoolProps props;

  Widget buildBottomBtn(BuildContext context, bool shown) => AbsorbPointer(
        absorbing: !shown,
        child: Opacity(
          opacity: shown ? 1 : 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: PopButton(
                    topPadding: 15,
                    bottomPadding: 15,
                    loading: false,
                    justText: true,
                    onPress: () {
                      Provider.of<GlobalContentService>(context, listen: false)
                          .updateWatched(
                              props.school,
                              !Provider.of<GlobalContentService>(context, listen: false)
                                  .schools[props.school.school.id]!
                                  .watched)
                          .then((f) =>
                              f.fold((_) => null, (errMsg) => context.read<NotificationsCubit>().showErr(errMsg)));
                    },
                    icon: CupertinoIcons.chevron_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: Provider.of<GlobalContentService>(context).schools[props.school.school.id]!.watched
                        ? "Unwatch school"
                        : "Watch school",
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: heightFraction(context, .3),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: Theme.of(context).colorScheme.shadow,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                  Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius),
                              bottomRight: Radius.circular(
                                  Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius),
                            ),
                            child: Zoomable(
                              child: CachedOnlineImage(
                                url: props.school.school.imgUrl,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 10,
                        child: SafeArea(
                          child: CircleIconBtn(
                            onTap: () => router.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        props.school.school.name,
                        style: kDisplay2.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isPlural(props.school.school.dailyHottests)
                            ? "${addCommasToNumber(props.school.school.dailyHottests)} hottests 🔥"
                            : "${addCommasToNumber(props.school.school.dailyHottests)} hottest 🔥",
                        style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        props.school.school.abbr,
                        style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: [
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.secondary,
                            onTap: () {
                              context
                                  .read<SchoolsDrawerCubit>()
                                  .setSelectedSchoolInUI(SelectedSchool(props.school.school.id));
                              router.go("/home");
                              Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(0);
                              Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
                            },
                            text: "Jump to this school's feed",
                          ),
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.secondary,
                            onTap: () => context.read<QuickActionsCubit>().locateOnMaps(
                                props.school.school.lat.toDouble(),
                                props.school.school.lon.toDouble(),
                                props.school.school.name),
                            text: "Locate on map",
                          ),
                          if (!sl.get<UserAuthService>().isAnon)
                            IgnorePointer(
                              ignoring:
                                  Provider.of<GlobalContentService>(context).schools[props.school.school.id]!.home,
                              child: SimpleTextButton(
                                disabled:
                                    Provider.of<GlobalContentService>(context).schools[props.school.school.id]!.home,
                                bgColor: Theme.of(context).colorScheme.surface,
                                textColor: Theme.of(context).colorScheme.secondary,
                                onTap: () async => await Provider.of<GlobalContentService>(context, listen: false)
                                    .setHome(props.school)
                                    .then((f) => f.fold(
                                        (_) => null, (errMsg) => context.read<NotificationsCubit>().showErr(errMsg))),
                                text: Provider.of<GlobalContentService>(context).schools[props.school.school.id]!.home
                                    ? "Current home school"
                                    : "Set as home school",
                              ),
                            ),
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.secondary,
                            onTap: () => context.read<QuickActionsCubit>().launchWebsite(props.school.school.website),
                            text: "Website",
                          ),
                        ],
                      ),
                      if (!sl.get<UserAuthService>().isAnon) buildBottomBtn(context, false), // for sizing reasons
                      const SimulatedBottomSafeArea(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!sl.get<UserAuthService>().isAnon) buildBottomBtn(context, true)
        ],
      ),
    );
  }
}
