import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';
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
    "computer science",
    "visual arts",
    "engineering",
    "history",
    "education",
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ClipRRect(
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
                const AnimatedLoadText(
                  text: "Selections save automatically.",
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
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        looping: false,
                        itemExtent: 35,
                        onSelectedItemChanged: (newIndex) {
                          setState(() {
                            index = newIndex;
                          });
                        },
                        children: items
                            .map((i) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Center(
                                    child: Text(
                                      i,
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
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.header,
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      items[index],
                      style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                Icon(CupertinoIcons.chevron_forward,
                    color: Theme.of(context).colorScheme.onSurface),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
