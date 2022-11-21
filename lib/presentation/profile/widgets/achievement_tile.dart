import 'package:flutter/material.dart';

import 'achievement_builder.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key, required this.achievement});

  final TempAchievement achievement;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: achievement.aspectRatio,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
