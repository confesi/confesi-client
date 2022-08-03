import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteTile extends StatelessWidget {
  const VoteTile({
    required this.value,
    required this.icon,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  final int value;
  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("print"),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onBackground,
              width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: kDetail.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 12,
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
