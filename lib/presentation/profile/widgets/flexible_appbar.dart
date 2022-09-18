import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/profile/widgets/profile_pic_with_text.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlexibleAppbar extends StatelessWidget {
  const FlexibleAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: SizedBox(
                width: widthFraction(context, 1),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: ProfilePicWithText(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
