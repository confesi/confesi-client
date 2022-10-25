import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class GenreTile extends StatelessWidget {
  const GenreTile({
    super.key,
    required this.text,
    this.isSelected = false,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TouchableOpacity(
        onTap: () => print("tap"),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              text,
              style: kBody.copyWith(
                color: isSelected ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
