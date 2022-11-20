import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'loading.dart';

class AlertIndicator extends StatelessWidget {
  const AlertIndicator({
    Key? key,
    required this.message,
    required this.onPress,
    this.isLoading = false,
  }) : super(key: key);

  final String message;
  final VoidCallback onPress;
  final bool isLoading;

  // TODO: have loading state if there's a button, so that you can have special case inside cubit for loading again called after error, so it shows on button and not again on empty screen.
  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onPress(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isLoading
                    ? const LoadingIndicator()
                    : Text(
                        message,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            )),
      ),
    );
  }
}
