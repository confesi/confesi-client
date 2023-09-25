import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/constants.dart';
import 'alert.dart';
import 'loading_cupertino.dart';
import '../behaviours/animated_bobbing.dart';

class StateMessage {
  final String? message;
  final VoidCallback onTap;
  const StateMessage(this.message, this.onTap);
}

class LoadingOrAlert extends StatelessWidget {
  const LoadingOrAlert(
      {required this.message, required this.isLoading, super.key, this.isLogo = true, this.onLoadNoSpinner = false});

  final StateMessage message;
  final bool isLoading;
  final bool isLogo;
  final bool onLoadNoSpinner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Center(
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Stack(
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: isLoading ? 0 : 1,
                  child: AlertIndicator(
                    isLogo: isLogo,
                    message: message.message ?? "",
                    onPress: () => message.onTap(),
                  ),
                ),
                Positioned.fill(
                  child: WidgetOrNothing(
                    showWidget: !onLoadNoSpinner,
                    child: Center(
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 250),
                        scale: isLoading ? 1 : 0,
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: isLogo
                              ? Bobbing(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      constraints: const BoxConstraints(maxHeight: 20),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        walrusHeadImgPath,
                                      ),
                                    ),
                                  ),
                                )
                              : LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
