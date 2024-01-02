import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confesi/application/user/cubit/awards_cubit.dart';
import 'package:confesi/presentation/profile/widgets/award_tile.dart';
import 'package:confesi/presentation/shared/behaviours/init_opacity.dart';
import 'package:confesi/presentation/shared/behaviours/init_transform.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/models/award_total.dart';
import 'package:confesi/models/award_type.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AwardsCubit, AwardsState>(
      builder: (context, state) {
        if (state is AwardsData) {
          List<AwardTile> tiles = genAwardTiles(context, state);
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1,
                ),
                itemCount: tiles.length,
                itemBuilder: (BuildContext context, int index) {
                  return InitOpacity(child: InitTransform(child: InitOpacity(child: tiles[index])));
                },
              ),
            ],
          );
        } else {
          return InitOpacity(
            child: LoadingOrAlert(
              message: StateMessage(
                  state is AwardsError ? state.message : "Unknown error", () => context.read<AwardsCubit>().load()),
              isLoading: state is AwardsLoading,
            ),
          );
        }
      },
    );
  }
}
