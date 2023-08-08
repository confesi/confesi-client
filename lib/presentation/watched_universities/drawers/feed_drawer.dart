import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../init.dart';
import '../../../models/school_with_metadata.dart';
import '../../shared/buttons/simple_text.dart';
import '../widgets/section_accordian.dart';

class FeedDrawer extends StatefulWidget {
  const FeedDrawer({Key? key}) : super(key: key);

  @override
  State<FeedDrawer> createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
  Widget buildBody(BuildContext context, SchoolsDrawerState state) {
    if (state is SchoolsDrawerData) {
      final selectedSchoolData = Provider.of<GlobalContentService>(context).schools[state.selectedId];
      if (selectedSchoolData == null || Provider.of<GlobalContentService>(context).schools[state.homeId] == null) {
        return LoadingOrAlert(
          isLoading: false,
          message: StateMessage("Unknown error", () => context.read<SchoolsDrawerCubit>().loadSchools()),
        );
      }
      final selectedSchoolName = selectedSchoolData.name;

      final allSchools =
          state.schoolIds.map((schoolId) => Provider.of<GlobalContentService>(context).schools[schoolId]).toList();

      final watchedSchools = allSchools.whereType<SchoolWithMetadata>().where((school) => school.watched).toList();
      print(Provider.of<GlobalContentService>(context).schools);
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
                          selectedSchoolName,
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
                        text: Provider.of<GlobalContentService>(context).schools[state.homeId]!.name,
                        onTap: () => context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(state.homeId),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Watched universities",
                    items: [
                      ...watchedSchools
                          .where((school) => school.watched && !school.home)
                          .map((watchedSchool) => DrawerUniversityTile(
                                onSwipe: () => context
                                    .read<SchoolsDrawerCubit>()
                                    .updateSchoolInUI(watchedSchool.id, watched: false),
                                text: watchedSchool.name,
                                onTap: () => context.read<SchoolsDrawerCubit>().setSelectedSchoolInUI(watchedSchool.id),
                              )),
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
          () => context.read<SchoolsDrawerCubit>().loadSchools(),
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
