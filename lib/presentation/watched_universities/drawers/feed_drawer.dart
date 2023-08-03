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
  Widget buildBody(BuildContext context, SchoolsDrawerState state) {
    if (state is SchoolsDrawerData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.secondary,
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
                      "University of British Columbia",
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
                    title: "Home university",
                    items: [
                      DrawerUniversityTile(
                        text: "University of Victoria",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Special",
                    items: [
                      DrawerUniversityTile(
                        text: "Random university",
                        onTap: () => print("tap"),
                      ),
                      DrawerUniversityTile(
                        text: "All universities mixed",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Confesi Beta",
                    items: [
                      DrawerUniversityTile(
                        text: "Updates",
                        onTap: () => print("tap"),
                      ),
                      DrawerUniversityTile(
                        text: "Announcements",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  SectionAccordian(
                    startsOpen: false,
                    bottomBorder: true,
                    title: "Watched universities",
                    items: [
                      DrawerUniversityTile(
                        text: "University of the Fraser Valley",
                        onTap: () => print("tap"),
                      ),
                      DrawerUniversityTile(
                        text: "University of British Columbia Okanagan",
                        onTap: () => print("tap"),
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
