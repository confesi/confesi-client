import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableSection extends StatelessWidget {
  const SlidableSection({
    required this.icon,
    required this.onPress,
    required this.text,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPress;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TouchableOpacity(
          onTap: () {
            Slidable.of(context)?.close();
            onPress();
          },
          child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
