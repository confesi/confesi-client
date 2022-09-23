import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../behaviours/touchable_opacity.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    this.popContext = true,
    required this.onTap,
    required this.text,
    required this.icon,
    this.isRed = false,
    Key? key,
  }) : super(key: key);

  final bool popContext;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        popContext ? Navigator.pop(context) : null;
        onTap();
      },
      child: InitScale(
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isRed
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: kDetail.copyWith(
                    color: isRed
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
