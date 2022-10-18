import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    required this.bodyText,
    required this.headerText,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String headerText;
  final String bodyText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          headerText,
          style: kDetail.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 5),
        TouchableOpacity(
          onTap: () => onTap(),
          child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                bodyText,
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
