import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/typography.dart';
import '../sheets/picker.dart';
import 'touchable_opacity.dart';

class DetailsButton extends StatefulWidget {
  const DetailsButton({required this.header, required this.body, Key? key}) : super(key: key);

  final String header;
  final String body;

  @override
  State<DetailsButton> createState() => _DetailsButtonState();
}

class _DetailsButtonState extends State<DetailsButton> {
  final items = [
    "business",
    "computer science",
    "education",
    "engineering",
    "fine arts",
    "human and social development",
    "humanities",
    "law",
    "science",
    "social sciences",
  ];

  int index = 0;

  void updateState(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => showPickerSheet(context, items, index, widget.header, updateState),
      child: Container(
        // transparent makes it a big hitbox
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.header,
                        style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        items[index],
                        style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(CupertinoIcons.chevron_forward,
                    color: Theme.of(context).colorScheme.onBackground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
