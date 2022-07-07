import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class ReactionButton extends StatelessWidget {
  const ReactionButton({required this.icon, required this.count, Key? key}) : super(key: key);

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                count.toString(),
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
