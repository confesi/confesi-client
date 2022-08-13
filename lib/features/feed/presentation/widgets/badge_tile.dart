import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/features/feed/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({
    required this.badge,
    Key? key,
  }) : super(key: key);

  final Badge badge;

  MaterialColor getColor() {
    switch (badge) {
      case Badge.loved:
        return Colors.pink;
      case Badge.hated:
        return Colors.green;
      default:
        throw ServerException();
    }
  }

  String getText() {
    switch (badge) {
      case Badge.loved:
        return "Loved";
      case Badge.hated:
        return "Hated";
      default:
        throw ServerException();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        color: getColor()[100],
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(color: getColor(), width: .7),
      ),
      child: Text(
        getText(),
        style: kDetail.copyWith(color: getColor(), fontSize: 12),
      ),
    );
  }
}
