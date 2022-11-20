import 'package:flutter/material.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key, required this.element});

  final dynamic element;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: element.aspectRatio,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
