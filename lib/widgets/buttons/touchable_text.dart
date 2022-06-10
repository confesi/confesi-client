import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

import '../../constants/typography.dart';

class TouchableTextButton extends StatelessWidget {
  const TouchableTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("TAP"),
      child: Container(
        width: double.infinity,
        // transparent hitbox trick
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Logout",
            style: kBody.copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
