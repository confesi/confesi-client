import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ItemSelector extends StatelessWidget {
  const ItemSelector({
    super.key,
    required this.text,
    this.bottomPadding = 0.0,
    required this.onTap,
  });

  final String text;
  final double bottomPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          TouchableOpacity(
            onTap: () => onTap(),
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: .5,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: 24,
                    child: Center(
                      child: TextField(
                        enableSuggestions: false,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: "...",
                          hintStyle: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
