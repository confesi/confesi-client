import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:flutter/material.dart';

import 'alert.dart';
import 'loading_cupertino.dart';
import '../behaviours/animated_bobbing.dart';

class StateMessage {
  final String? message;
  final VoidCallback onTap;
  const StateMessage(this.message, this.onTap);
}

class LoadingOrAlert extends StatelessWidget {
  const LoadingOrAlert({required this.message, required this.isLoading, super.key, this.isLogo = true});

  final StateMessage message;
  final bool isLoading;
  final bool isLogo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
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
                  child: Center(
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: isLoading ? 1 : 0,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: isLogo
                            ? InitScale(
                                child: Bobbing(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      constraints: const BoxConstraints(maxHeight: 20),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.onBackground,
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Image.asset(
                                        "assets/images/logos/logo_transparent.png",
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.primary),
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
