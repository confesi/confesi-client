import 'dart:ui';

import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/text/header_group.dart';

class HottestTile extends StatefulWidget {
  const HottestTile({
    required this.color,
    required this.currentIndex,
    required this.thisIndex,
    Key? key,
  }) : super(key: key);

  final Color color;
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
              duration: const Duration(milliseconds: 400),
              opacity: isSelected ? 1 : 0.5,
              child: AnimatedContainer(
                width: double.infinity,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                height:
                    isSelected ? constraints.maxHeight : constraints.maxHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: HeaderGroupText(
                        left: true,
                        header: 'University of British Columbia',
                        body: 'Victoria, BC',
                      ),
                    ),
                    LineLayout(
                      color: Theme.of(context).colorScheme.onBackground,
                    )
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
