import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class DisclaimerText extends StatelessWidget {
  const DisclaimerText({
    Key? key,
    required this.text,
    this.onTap,
    this.btnText,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;
  final String? btnText;

  @override
  Widget build(BuildContext context) {
    assert(
      (onTap == null && btnText == null) || (onTap != null && btnText != null),
      "Both onTap and btnText should be either null or non-null.",
    );

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                    child: Text(
                      text,
                      style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                      child: TouchableScale(
                        onTap: () => onTap?.call(),
                        child: Text(
                          btnText ?? "Learn more",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
