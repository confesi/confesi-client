import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
    );
  }
}
