import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../application/feed/cubit/schools_drawer_cubit.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../widgets/section_accordian.dart';
import '../../shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';

class FeedDrawer extends StatelessWidget {
  const FeedDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalContentService = Provider.of<GlobalContentService>(context);

    final schools = globalContentService.schools.values.whereType<SchoolWithMetadata>().toList();

    Widget buildChild(BuildContext context, SchoolsDrawerState state) {
      if (state is SchoolsDrawerData) {
        return ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.only(bottom: bottomSafeArea(context)),
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                ),
              ),
              child: Column(
                children: [
                  SimpleTextButton(
                    infiniteWidth: true,
                    onTap: () => verifiedUserOnly(context, () => router.push("/schools/search")),
                    text: "Edit schools",
                  ),
                ],
              ),
            ),
            ...schools.where((school) => school.home).map((watchedHomeSchool) => DrawerUniversityTile(
                  text: "Home: ${watchedHomeSchool.name}",
                  onTap: () {
                    context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedSchool(watchedHomeSchool.id));
                    Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
                  },
                )),
            IgnorePointer(
              ignoring: state.isLoadingRandomSchool,
              child: DrawerUniversityTile(
                isLoading: state.isLoadingRandomSchool,
                text: "Random 🎲",
                // context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedRandom())
                onTap: () async {
                  await context
                      .read<SchoolsDrawerCubit>()
                      .getAndSetRandomSchool(
                          state.selected is SelectedSchool ? (state.selected as SelectedSchool).id : null)
                      .then((value) => Provider.of<PostsService>(context, listen: false).reloadAllFeeds());
                },
              ),
            ),
            DrawerUniversityTile(
              text: "All ✨",
              onTap: () {
                context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedAll());
                Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
              },
            ),
            SectionAccordian(
              startsOpen: false,
              bottomBorder: true,
              topBorder: true,
              title: "Watched schools (${schools.where((school) => school.watched).length})",
              items: [
                ...schools.where((school) => school.watched).map((watchedSchool) => DrawerUniversityTile(
                      onSwipe: () => Provider.of<GlobalContentService>(context, listen: false)
                          .updateWatched(watchedSchool, false)
                          .then((f) =>
                              f.fold((_) => null, (errMsg) => context.read<NotificationsCubit>().showErr(errMsg))),
                      text: watchedSchool.name,
                      onTap: () {
                        context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedSchool(watchedSchool.id));
                        Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
                      },
                    )),
              ],
            ),
          ],
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomSafeArea(context)),
          child: LoadingOrAlert(
            message: StateMessage("Error loading", () => context.read<SchoolsDrawerCubit>().loadSchools()),
            isLoading: state is SchoolsDrawerLoading,
          ),
        );
      }
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            // linear gradient
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ],
              ),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Currently viewing",
                          style: kDetail.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          context.watch<SchoolsDrawerCubit>().state is SchoolsDrawerData
                              ? context.watch<SchoolsDrawerCubit>().selectedStr(context)
                              : context.watch<SchoolsDrawerCubit>().state is SchoolsDrawerLoading
                                  ? "Loading..."
                                  : "Error",
                          style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SwipeRefresh(
              onRefresh: () async => await context.read<SchoolsDrawerCubit>().loadSchools(),
              child: BlocBuilder<SchoolsDrawerCubit, SchoolsDrawerState>(
                builder: (context, state) => buildChild(context, state),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
