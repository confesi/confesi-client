import '../../../constants/shared/constants.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../behaviours/animated_bobbing.dart';
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
    this.btnMsg = "Retry",
    this.isLogo = true,
  }) : super(key: key);

  final bool isLogo;
  final String btnMsg;
  final String message;
  final VoidCallback onPress;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
          constraints: BoxConstraints(maxWidth: widthFraction(context, .75)),
          // Transparent hitbox trick
          color: Colors.transparent,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? isLogo
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: Bobbing(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                constraints: const BoxConstraints(maxHeight: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  walrusHeadImgPath,
                                ),
                              ),
                            ),
                          ))
                      : const LoadingCupertinoIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message,
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SimpleTextButton(
                          onTap: () => onPress(),
                          text: btnMsg,
                          bgColor: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ],
                    ),
            ),
          )),
    );
  }
}
