import 'dart:ui';

import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/text/header_group.dart';

class HottestTile extends StatefulWidget {
  const HottestTile({
    required this.currentIndex,
    required this.thisIndex,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final int thisIndex;

  @override
  State<HottestTile> createState() => _HottestTileState();
}

class _HottestTileState extends State<HottestTile> {
  bool get isSelected => widget.currentIndex == widget.thisIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1 : 0.75,
              child: AnimatedContainer(
                width: double.infinity,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: isSelected
                    ? constraints.maxHeight
                    : constraints.maxHeight * .8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: Text(
                        '14 comments · 341 likes · 93 hates',
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        child: Image.asset(
                          'assets/images/universities/uvic.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            right: 5,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '0${widget.thisIndex + 1}',
                                style: kFaded.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: HeaderGroupText(
                              onSecondaryColors: false,
                              multiLine: true,
                              spaceBetween: 20,
                              left: true,
                              header:
                                  "Clustermates can be so irreponsible. I seriously hate it. Last night, one came to my room drunk!",
                              body: 'UVic, Year 1',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
