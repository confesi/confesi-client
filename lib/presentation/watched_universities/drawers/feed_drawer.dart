import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/buttons/simple_text.dart';
import '../widgets/drawer_university_tile.dart';
import '../widgets/section_accordian.dart';

class FeedDrawer extends StatefulWidget {
  const FeedDrawer({Key? key}) : super(key: key);

  @override
  State<FeedDrawer> createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
  String getSelectedSchool(SchoolsDrawerData state) {
    if (state.selected is SelectedId) {
      return state.schools.firstWhere((school) => school.id == (state.selected as SelectedId).id).name;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.secondary,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
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
                        style: kDisplay1.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ScrollableView(
              physics: const BouncingScrollPhysics(),
              hapticsEnabled: false,
              inlineBottomOrRightPadding: bottomSafeArea(context),
              scrollBarVisible: false,
              controller: ScrollController(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SimpleTextButton(
                      infiniteWidth: true,
                      onTap: () => router.push("/schools/search"),
                      text: "Edit watched schools",
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
                        onTap: () => context.read<SchoolsDrawerCubit>().setCurrentSchool(SelectedId(userSchool.id)),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: true,
                    bottomBorder: true,
                    title: "Special",
                    items: [
                      DrawerUniversityTile(
                        text: "Random school",
                        onTap: () => context.read<SchoolsDrawerCubit>().setCurrentSchool(SelectedRandom()),
                      ),
                      DrawerUniversityTile(
                        text: "All schools",
                        onTap: () => context.read<SchoolsDrawerCubit>().setCurrentSchool(SelectedAll()),
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
                          text: watchedSchool.name,
                          onTap: () =>
                              context.read<SchoolsDrawerCubit>().setCurrentSchool(SelectedId(watchedSchool.id)),
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
          isLoading: state is SchoolsDrawerLoading);
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
