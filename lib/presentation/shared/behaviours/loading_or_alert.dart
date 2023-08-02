import 'package:flutter/material.dart';

import '../indicators/alert.dart';
import '../indicators/loading_cupertino.dart';

class LoadingOrAlert extends StatelessWidget {
  const LoadingOrAlert({this.message, this.onTap, required this.isLoading, super.key});

  final String? message;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Stack(
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: message != null && onTap != null && !isLoading ? 1 : 0,
                  child: AlertIndicator(
                    message: message ?? "Retry",
                    onPress: () => onTap!(),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 250),
                    scale: message != null && onTap != null && !isLoading ? 0 : 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
