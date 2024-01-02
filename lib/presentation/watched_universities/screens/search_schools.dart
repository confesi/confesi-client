import 'package:confesi/application/feed/cubit/search_schools_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/funcs/debouncer.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/numbers/distance_formatter.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../init.dart';
import '../../shared/indicators/loading_or_alert.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/textfields/expandable_textfield.dart';
import '../widgets/searched_school_tile.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

class SearchSchoolsScreen extends StatefulWidget {
  const SearchSchoolsScreen({Key? key}) : super(key: key);

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
                              onSetHome: () async => await Provider.of<GlobalContentService>(context, listen: false)
                                  .setHome(school)
                                  .then((f) => f.fold(
                                      (_) => null, (errMsg) => context.read<NotificationsCubit>().showErr(errMsg))),
                              onWatchChange: (isWatching) => Provider.of<GlobalContentService>(context, listen: false)
                                  .updateWatched(school, isWatching)
                                  .then((f) => f.fold(
                                      (_) => null, (errMsg) => context.read<NotificationsCubit>().showErr(errMsg))),
                              home: Provider.of<GlobalContentService>(context).schools[school.school.id]!.home,
                              watched: Provider.of<GlobalContentService>(context).schools[school.school.id]!.watched,
                              topText: school.school.name,
                              middleText: distanceFormatter(context, school.distance),
                              bottomText: school.school.abbr,
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
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: borderSize,
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
                        CircleIconBtn(
                          bgColor: Theme.of(context).colorScheme.background,
                          color: Theme.of(context).colorScheme.primary,
                          icon: CupertinoIcons.xmark,
                          onTap: () => router.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SearchSchoolsCubit, SearchSchoolsState>(
                    builder: (context, state) => Container(
                      color: Theme.of(context).colorScheme.shadow,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: buildBody(context, state),
                      ),
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
