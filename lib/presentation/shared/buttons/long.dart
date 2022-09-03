import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/indicators/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key? key,
    this.isLoading = false,
    required this.onPress,
  }) : super(key: key);

  final bool isLoading;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading ? true : false,
      child: TouchableOpacity(
        onTap: () => onPress(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Container(
              key: UniqueKey(),
              constraints: const BoxConstraints(minHeight: 25),
              child: Center(
                child: isLoading
                    ? LoadingIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : Text(
                        'Submit Confession',
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
