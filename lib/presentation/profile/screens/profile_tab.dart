import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/profile/widgets/achievement_tile.dart';
import 'package:Confessi/presentation/profile/widgets/profile_pic_with_text.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';

// TODO: add automatickeepalive mixin to tabs?

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: Wrap(
              children: const [
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
                AchievementTile(),
              ],
            ),
          ),
        );
      },
    );
  }
}
