import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/buttons/action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ActionButton(
              loading: isLoading,
              icon: CupertinoIcons.arrow_2_circlepath,
              onPress: () => onPress(),
              text: 'Retry',
            )
          ],
        ),
      ),
    );
  }
}
