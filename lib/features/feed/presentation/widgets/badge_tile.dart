import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/features/feed/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer, width: .7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.secondaryContainer,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}
