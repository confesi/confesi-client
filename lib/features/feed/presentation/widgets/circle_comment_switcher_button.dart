import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleCommentSwitcherButton extends StatelessWidget {
  const CircleCommentSwitcherButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print('tap'),
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.error, // surface
        ),
        child: const Center(
          child: Icon(CupertinoIcons.up_arrow),
        ),
      ),
    );
  }
}
