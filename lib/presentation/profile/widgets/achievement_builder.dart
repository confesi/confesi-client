import 'dart:math';

import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/presentation/profile/widgets/achievement_tile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/profile/entities/achievement_tile_entity.dart';

// class TempAchievement {
//   final double aspectRatio;
//   final String id;
//   final String title;
//   final String desc;
//   final int quantity;

//   TempAchievement({
//     required this.aspectRatio,
//     required this.desc,
//     required this.id,
//     required this.quantity,
//     required this.title,
//   });
// }

// List<TempAchievement> data = [
//   TempAchievement(aspectRatio: 4 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 3 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 1 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 1, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 1 / 4, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 4 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 4 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 1 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
//   TempAchievement(aspectRatio: 1, desc: "desc", id: "id", quantity: 1, title: "title"),
// ];

enum ColumnSide { left, right } // Which side of the column to build to.

class AchievementBuilder extends StatelessWidget {
  const AchievementBuilder({super.key, required this.achievements});

  final List<AchievementTileEntity> achievements;

  List<Widget> delegateItems(ColumnSide columnToReturn) {
    List<Widget> leftColumn = [];
    List<Widget> rightColumn = [];
    double leftLength = 0.0;
    double rightLength = 0.0;
    for (var element in achievements) {
      if (leftLength > rightLength) {
        // add right
        rightLength += pow(element.aspectRatio, -1);
        rightColumn.add(AchievementTile(
            rarity: element.rarity,
            title: element.title,
            aspectRatio: element.aspectRatio,
            achievementImgUrl: element.achievementImgUrl,
            description: element.description,
            quantity: element.quantity));
      } else {
        // add left
        leftLength += pow(element.aspectRatio, -1);
        leftColumn.add(AchievementTile(
            rarity: element.rarity,
            title: element.title,
            aspectRatio: element.aspectRatio,
            achievementImgUrl: element.achievementImgUrl,
            description: element.description,
            quantity: element.quantity));
      }
    }
    return columnToReturn == ColumnSide.left ? leftColumn : rightColumn;
  }

  @override
  Widget build(BuildContext context) {
    return delegateItems(ColumnSide.left).length + delegateItems(ColumnSide.right).length == 0
        ? Center(
            child: FractionallySizedBox(
              widthFactor: .8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.flag_circle,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 36,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Here's where your achievements would be... if you had any.",
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.75),
                  child: Column(
                    children: delegateItems(ColumnSide.left),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.75),
                  child: Column(
                    children: delegateItems(ColumnSide.right),
                  ),
                ),
              ),
            ],
          );
  }
}
