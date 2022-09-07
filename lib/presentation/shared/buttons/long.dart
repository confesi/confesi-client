import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/indicators/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key? key,
    this.isLoading = false,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  final bool isLoading;
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading ? true : false,
      child: TouchableOpacity(
        onTap: () => onPress(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? Center(
                      key: const ValueKey('indicator'),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0,
                              child: Text(
                                "text",
                                style: kBody.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Center(
                              child: LoadingIndicator(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      key: const ValueKey('text'),
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: Container(
                              color: Colors.green.withOpacity(0.2),
                              child: Center(
                                child: LoadingIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: Text(
                              text,
                              style: kBody.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
