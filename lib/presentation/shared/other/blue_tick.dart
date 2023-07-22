import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet_with_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlueTick extends StatelessWidget {
  const BlueTick({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => showInfoSheetWithAction(context, "Verified student", "We've confirmed that this is a real student.",
          () => Navigator.pushNamed(context, "/settings/verified_student_perks"), "Verify yourself"),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          CupertinoIcons.check_mark,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
