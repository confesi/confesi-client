import 'dart:math';

import 'package:Confessi/presentation/profile/widgets/achievement_tile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class TempAchievement {
  final double aspectRatio;
  final String id;
  final String title;
  final String desc;
  final int quantity;

  TempAchievement({
    required this.aspectRatio,
    required this.desc,
    required this.id,
    required this.quantity,
    required this.title,
  });
}

List<TempAchievement> data = [
  TempAchievement(aspectRatio: 4 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 3 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 1 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 1, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 1 / 4, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 4 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 4 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 1 / 2, desc: "desc", id: "id", quantity: 1, title: "title"),
  TempAchievement(aspectRatio: 1, desc: "desc", id: "id", quantity: 1, title: "title"),
];

enum ColumnSide { left, right } // Which side of the column to build to.

class AchievementBuilder extends StatelessWidget {
  const AchievementBuilder({super.key});

  List<Widget> delegateItems(ColumnSide columnToReturn) {
    List<Widget> leftColumn = [];
    List<Widget> rightColumn = [];
    double leftLength = 0.0;
    double rightLength = 0.0;
    for (var element in data) {
      if (leftLength > rightLength) {
        // add right
        rightLength += pow(element.aspectRatio, -1);
        print("right: ${element.aspectRatio}, total: $rightLength");
        rightColumn.add(AchievementTile(element: element));
      } else {
        // add left
        leftLength += pow(element.aspectRatio, -1);
        print("left: ${element.aspectRatio}, total: $leftLength");
        leftColumn.add(AchievementTile(element: element));
      }
    }
    return columnToReturn == ColumnSide.left ? leftColumn : rightColumn;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: delegateItems(ColumnSide.left),
          ),
        ),
        Expanded(
          child: Column(
            children: delegateItems(ColumnSide.right),
          ),
        ),
      ],
    );
  }
}
