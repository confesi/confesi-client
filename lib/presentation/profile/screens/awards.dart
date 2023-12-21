import 'dart:math';
import 'package:confesi/application/user/cubit/awards_cubit.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/presentation/profile/widgets/award_tile.dart';
import 'package:confesi/presentation/shared/behaviours/init_opacity.dart';
import 'package:confesi/presentation/shared/behaviours/init_transform.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/shared/constants.dart';
import '../../../core/styles/typography.dart';
import '../../../models/award_total.dart';
import '../../../models/award_type.dart';
import '../../shared/behaviours/off.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/indicators/loading_or_alert.dart';

class AwardsScreen extends StatefulWidget {
  const AwardsScreen({super.key});

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AwardsCubit>().load();
  }

  List<AwardTile> genAwardTiles(BuildContext context, AwardsData data) {
    List<AwardTile> tiles = [];
    for (AwardType award in data.missing) {
      tiles.add(AwardTile(
        count: 0,
        title: award.name,
        desc: award.description,
        emoji: award.icon,
        fontSize: (widthFraction(context, 1) > maxStandardSizeOfContent
                ? maxStandardSizeOfContent
                : widthFraction(context, 1)) /
            3 /
            2.5,
      ));
    }
    for (AwardTotal award in data.has) {
      tiles.add(AwardTile(
        count: award.total,
        title: award.awardType.name,
        desc: award.awardType.description,
        emoji: award.awardType.icon,
        fontSize: (widthFraction(context, 1) > maxStandardSizeOfContent
                ? maxStandardSizeOfContent
                : widthFraction(context, 1)) /
            3 /
            2.5,
      ));
    }
    // alphabetical by title
    return tiles..sort((a, b) => a.title.compareTo(b.title));
  }

  Widget buildBody(BuildContext context, AwardsState state, BoxConstraints constraints) {
    if (state is AwardsData) {
      List<AwardTile> tiles = genAwardTiles(context, state);
      return SliverPadding(
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < maxStandardSizeOfContent
                ? 0
                : (constraints.maxWidth - maxStandardSizeOfContent) / 2),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 1,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                InitOpacity(child: InitTransform(child: InitOpacity(child: tiles[index]))),
            childCount: tiles.length,
          ),
        ),
      );
    } else {
      return SliverFillRemaining(
        child: InitOpacity(
          child: LoadingOrAlert(
            message: StateMessage(
                state is AwardsError ? state.message : "Unknown error", () => context.read<AwardsCubit>().load()),
            isLoading: state is AwardsLoading,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => context.read<AwardsCubit>().clear(),
      child: ThemeStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomScrollView(
                physics: context.watch<AwardsCubit>().state is AwardsData
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleIconBtn(
                              icon: CupertinoIcons.arrow_left,
                              onTap: () {
                                router.pop(context);
                              }),
                          Text(
                            "Your Achievements",
                            style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Off(
                            child: CircleIconBtn(
                              icon: CupertinoIcons.arrow_left,
                              onTap: () => router.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<AwardsCubit, AwardsState>(
                    builder: (context, state) => buildBody(context, state, constraints),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
