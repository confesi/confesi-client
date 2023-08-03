import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/application/feed/cubit/search_schools_cubit.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/funcs/debouncer.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/numbers/distance_formatter.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../init.dart';
import '../../shared/indicators/loading_or_alert.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/textfields/expandable_textfield.dart';
import '../widgets/searched_university_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

class SearchSchoolsScreen extends StatefulWidget {
  const SearchSchoolsScreen({super.key});

  @override
  State<SearchSchoolsScreen> createState() => _SearchSchoolsScreenState();
}

class _SearchSchoolsScreenState extends State<SearchSchoolsScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textEditingController.addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    });
    context.read<SearchSchoolsCubit>().loadNearby();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context, SearchSchoolsState state) {
    if (state is SearchSchoolsData) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          key: const ValueKey("search_data"),
          color: Theme.of(context).colorScheme.shadow,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SwipeRefresh(
              onRefresh: () async {
                if (_textEditingController.text.isEmpty) {
                  await context.read<SearchSchoolsCubit>().loadNearby();
                } else {
                  await context.read<SearchSchoolsCubit>().search(_textEditingController.text);
                }
              },
              child: SizedBox(
                height: heightFraction(context, 1),
                child: ScrollableView(
                  inlineTopOrLeftPadding: 5,
                  scrollBarVisible: false,
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  hapticsEnabled: false,
                  controller: ScrollController(),
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: state.schools.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "No schools found",
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Column(
                          children: state.schools.map((school) {
                            return SearchedSchoolTile(
                              onHomeChange: (newValue) async {
                                await context.read<SearchSchoolsCubit>().setHome(school.id).then(
                                      (succeeded) => succeeded
                                          ? context.read<SchoolsDrawerCubit>().updateHomeSchool(school.id)
                                          : null,
                                    );
                              },
                              onWatchChange: (newValue) async {
                                await context.read<SearchSchoolsCubit>().updateWatched(school.id, newValue).then(
                                      (succeeded) => succeeded
                                          ? newValue
                                              ? context.read<SchoolsDrawerCubit>().addWatchedSchool(school)
                                              : context.read<SchoolsDrawerCubit>().removeWatchedSchool(school.id)
                                          : null,
                                    );
                              },
                              home: school.home,
                              watched: school.watched,
                              onPress: () => print("tap"),
                              topText: school.name,
                              middleText: distanceFormatter(context, school.distance),
                              bottomText: school.abbr,
                            );
                          }).toList(),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        key: state is SearchSchoolsLoading ? const ValueKey("search_loading") : const ValueKey("search_error"),
        padding: EdgeInsets.only(bottom: bottomSafeArea(context)),
        child: LoadingOrAlert(
          message: StateMessage(state is SearchSchoolsError ? state.message : null,
              () => context.read<SearchSchoolsCubit>().loadNearby()),
          isLoading: state is SearchSchoolsLoading,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: .8,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: ExpandableTextfield(
                            onChange: (value) => value.isEmpty
                                ? sl.get<Debouncer>().run(() => context.read<SearchSchoolsCubit>().loadNearby())
                                : sl.get<Debouncer>().run(() => context.read<SearchSchoolsCubit>().search(value)),
                            color: Theme.of(context).colorScheme.background,
                            maxLines: 1,
                            controller: _textEditingController,
                            hintText: "Search schools",
                          ),
                        ),
                        const SizedBox(width: 15),
                        CircleIconBtn(onTap: () => router.pop(context)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SearchSchoolsCubit, SearchSchoolsState>(
                    builder: (context, state) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: buildBody(context, state),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
