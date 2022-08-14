import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/features/feed/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({
    Key? key,
    required this.darkColor,
    required this.lightColor,
    required this.text,
  }) : super(key: key);

  final Color darkColor;
  final Color lightColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(color: darkColor, width: .7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.heart,
            size: 14,
            color: darkColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: kDetail.copyWith(color: darkColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
