import 'package:confesi/core/services/global_content/global_content.dart';
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
            Padding(
              padding: const EdgeInsets.all(15),
              child: SimpleTextButton(
                infiniteWidth: true,
                onTap: () => router.push("/schools/search"),
                text: "Edit schools",
              ),
            ),
            SectionAccordian(
              startsOpen: false,
              topBorder: true,
              title: "Home school",
              items: [
                ...schools.where((school) => school.home).map((watchedHomeSchool) => DrawerUniversityTile(
                      text: watchedHomeSchool.name,
                      onTap: () => context
                          .read<SchoolsDrawerCubit>()
                          .setSelectedSchoolInUI(SelectedSchool(watchedHomeSchool.id)),
                    )),
              ],
            ),
            SectionAccordian(
              startsOpen: false,
              topBorder: true,
              title: "Special",
              items: [
                DrawerUniversityTile(
                  text: "Random",
                  // context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedRandom())
                  onTap: () => print("TODO: random"),
                ),
                DrawerUniversityTile(
                  text: "All",
                  onTap: () => context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedAll()),
                )
              ],
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
                      onTap: () =>
                          context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(SelectedSchool(watchedSchool.id)),
                    )),
              ],
            ),
          ],
        );
      } else {
        return LoadingOrAlert(
          onLoadNoSpinner: state is! SchoolsDrawerLoading,
          message: StateMessage("Error loading", () => context.read<SchoolsDrawerCubit>().loadSchools()),
          isLoading: state is SchoolsDrawerLoading,
        );
      }
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 175),
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondary,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
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
                                ? context
                                    .watch<SchoolsDrawerCubit>()
                                    .selected(context, (context.read<SchoolsDrawerCubit>().state as SchoolsDrawerData))
                                : "Loading...",
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
                  builder: (context, state) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: buildChild(context, state),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
