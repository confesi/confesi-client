import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleRowToggle extends StatefulWidget {
  const SimpleRowToggle({
    super.key,
    required this.isToggled,
  });

  final bool isToggled;

  @override
  State<SimpleRowToggle> createState() => _SimpleRowToggleState();
}

class _SimpleRowToggleState extends State<SimpleRowToggle> {
  bool tog = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoSwitch(
          activeColor: Theme.of(context).colorScheme.secondary,
          thumbColor: Theme.of(context).colorScheme.onPrimary,
          trackColor: Theme.of(context).colorScheme.surface,
          value: tog,
          onChanged: (newValue) => setState(() {
            tog = !tog;
          }),
        ),
      ],
    );
  }
}
