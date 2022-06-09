import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/scrollbar.dart';
import 'package:flutter_mobile_client/widgets/text/animated_load.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailsButton extends StatelessWidget {
  DetailsButton({required this.header, required this.body, Key? key}) : super(key: key);

  final String header;
  final String body;
  final FixedExtentScrollController controller = FixedExtentScrollController();

  final items = [
    "computer science",
    "visual arts",
    "engineering",
    "history",
    "education",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TouchableOpacity(
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
                    header,
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
                          // diameterRatio: 200,
                          scrollController: controller,
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
                          onSelectedItemChanged: (index) => print(index),
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
                      header,
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      body,
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
