import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/scrollbar.dart';
import 'package:flutter_mobile_client/widgets/text/animated_load.dart';

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

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ClipRRect(
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            body: Column(
              children: [
                const ScrollbarLayout(),
                const SizedBox(height: 15),
                Text(
                  widget.header,
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  "Change your category",
                  style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ScrollConfiguration(
                      behavior: NoOverScrollSplash(),
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: index),
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        looping: false,
                        itemExtent: 40,
                        onSelectedItemChanged: (newIndex) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            index = newIndex;
                          });
                        },
                        children: items
                            .map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Center(
                                    child: Text(
                                      item,
                                      style: kBody.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
