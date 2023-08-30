import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:confesi/presentation/shared/text/disclaimer_text.dart';
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

class FeedDrawer extends StatefulWidget {
  const FeedDrawer({Key? key}) : super(key: key);

  @override
  State<FeedDrawer> createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
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
                  bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
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
            if (!state.isGuest)
              ...schools.where((school) => school.home).map((watchedHomeSchool) => DrawerUniversityTile(
                    text: "Home: ${watchedHomeSchool.school.name}",
                    onTap: () {
                      context
                          .read<SchoolsDrawerCubit>()
                          .setSelectedSchoolInUI(SelectedSchool(watchedHomeSchool.school.id));
                      Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
                      // check if the current route can be popped as well
                      // if (mounted) router.pop();
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
                      .then((value) => (state is SchoolsDrawerData && (state.possibleErr is! SchoolsDrawerErr)
                          ? Provider.of<PostsService>(context, listen: false).reloadAllFeeds()
                          : null));
                  // only if drawer is still up, pop context
                  // if (mounted) router.pop();
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
            if (!state.isGuest)
              SectionAccordian(
                startsOpen: false,
                bottomBorder: false,
                topBorder: true,
                title: "Watched schools (${schools.where((school) => school.watched).length})",
                items: [
                  ...schools.where((school) => school.watched).map(
                        (watchedSchool) => DrawerUniversityTile(
                          onSwipe: () => Provider.of<GlobalContentService>(context, listen: false)
                              .updateWatched(watchedSchool, false)
                              .then((f) =>
                                  f.fold((_) => null, (errMsg) => context.read<NotificationsCubit>().showErr(errMsg))),
                          text: watchedSchool.school.name,
                          onTap: () {
                            context
                                .read<SchoolsDrawerCubit>()
                                .setSelectedSchoolInUI(SelectedSchool(watchedSchool.school.id));
                            Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
                            // if (mounted) router.pop();
                          },
                        ),
                      ),
                ],
              ),
            if (!state.isGuest)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
                  ),
                ),
              ),
            if (state.isGuest)
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: DisclaimerText(
                      text: "To watch schools, set your home, and jump between feeds, create an account.",
                      onTap: () => router.push("/register", extra: const RegistrationPops(true)),
                      btnText: "Create account ->",
                    ),
                  )
                ],
              ),
          ],
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomSafeArea(context) * 2),
          child: LoadingOrAlert(
            message: StateMessage(state is SchoolDrawerError ? state.message : "Error loading",
                () => context.read<SchoolsDrawerCubit>().loadSchools()),
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
              duration: const Duration(milliseconds: 350),
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
                          context.watch<SchoolsDrawerCubit>().state is SchoolsDrawerData
                              ? "Currently viewing"
                              : context.watch<SchoolsDrawerCubit>().state is SchoolsDrawerLoading
                                  ? "Loading..."
                                  : context.watch<SchoolsDrawerCubit>().state is SchoolsDrawerData &&
                                          (context.watch<SchoolsDrawerCubit>().state as SchoolsDrawerData).isGuest
                                      ? "To watch schools, set your home, and jump between feeds, create an account."
                                      : "Error",
                          style: kDetail.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        WidgetOrNothing(
                          showWidget: context.watch<SchoolsDrawerCubit>().state is SchoolsDrawerData,
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                context.watch<SchoolsDrawerCubit>().selectedStr(context),
                                style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
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
              child: BlocConsumer<SchoolsDrawerCubit, SchoolsDrawerState>(
                listener: (context, state) {
                  if (state is SchoolsDrawerData) {
                    Provider.of<PostsService>(context, listen: false).reloadAllFeeds();
                  }
                },
                builder: (context, state) => Container(
                  color: Theme.of(context).colorScheme.background,
                  child: buildChild(context, state),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
