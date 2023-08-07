import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/buttons/simple_text.dart';
import '../widgets/section_accordian.dart';

class FeedDrawer extends StatefulWidget {
  const FeedDrawer({Key? key}) : super(key: key);

  @override
  State<FeedDrawer> createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
  String getSelectedSchool(SchoolsDrawerData state) {
    if (state.selected is SelectedId) {
      final selectedId = (state.selected as SelectedId).id;
      final selectedSchool = state.schools.firstWhere((school) => school.id == selectedId);
      return selectedSchool.name; // Return the name if found, otherwise a fallback value.
    } else if (state.selected is SelectedAll) {
      return "All";
    } else if (state.selected is SelectedRandom) {
      return "Random";
    } else {
      throw Exception("Unknown 'selected' type");
    }
  }

  Widget buildBody(BuildContext context, SchoolsDrawerState state) {
    if (state is SchoolsDrawerData) {
      final userSchool = state.homeUniversity;
      final watchedSchools = state.schools.where((school) => school.watched).toList();
      watchedSchools.sort((a, b) => a.name.compareTo(b.name));

      return Column(
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
                          getSelectedSchool(state),
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
              onRefresh: () => context.read<SchoolsDrawerCubit>().loadWatchedSchools(),
              child: ListView(
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
                    topBorder: true,
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Home school",
                    items: [
                      DrawerUniversityTile(
                        text: userSchool.name,
                        onTap: () => context.read<SchoolsDrawerCubit>().setSelectedFeedInUI(SelectedId(userSchool.id)),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Special",
                    items: [
                      DrawerUniversityTile(
                        text: "Random school",
                        onTap: () => context.read<SchoolsDrawerCubit>().setSelectedFeedInUI(SelectedRandom()),
                      ),
                      DrawerUniversityTile(
                        text: "All schools",
                        onTap: () => context.read<SchoolsDrawerCubit>().setSelectedFeedInUI(SelectedAll()),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Watched universities",
                    items: [
                      for (final watchedSchool in watchedSchools)
                        DrawerUniversityTile(
                          onSwipe: () => context.read<SchoolsDrawerCubit>().removeWatchedSchool(watchedSchool.id),
                          text: watchedSchool.name,
                          onTap: () =>
                              context.read<SchoolsDrawerCubit>().setSelectedFeedInUI(SelectedId(watchedSchool.id)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return LoadingOrAlert(
        message: StateMessage(
          "Error loading",
          () => context.read<SchoolsDrawerCubit>().loadWatchedSchools(),
        ),
        isLoading: state is SchoolsDrawerLoading,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: BlocBuilder<SchoolsDrawerCubit, SchoolsDrawerState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: buildBody(context, state),
        ),
      ),
    );
  }
}
