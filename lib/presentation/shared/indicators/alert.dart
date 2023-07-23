import '../../../core/utils/sizing/width_fraction.dart';
import '../buttons/simple_text.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import 'loading_cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
          constraints: BoxConstraints(maxWidth: widthFraction(context, .8)),
          // Transparent hitbox trick.
          color: Colors.transparent,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? const LoadingCupertinoIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message,
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        SimpleTextButton(onTap: () => onPress(), text: "Retry"),
                      ],
                    ),
            ),
          )),
    );
  }
}
