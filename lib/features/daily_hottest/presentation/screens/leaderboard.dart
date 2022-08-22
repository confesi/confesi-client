import 'dart:math';

import 'package:Confessi/core/widgets/layout/appbar.dart';
import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:Confessi/core/widgets/sheets/info_sheet.dart';
import 'package:Confessi/features/daily_hottest/constants.dart';
import 'package:Confessi/features/daily_hottest/presentation/widgets/leaderboard_circle_tile.dart';
import 'package:Confessi/features/daily_hottest/presentation/widgets/leaderboard_rectangle_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Theme.of(context).colorScheme.shadow,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              AppbarLayout(
                centerWidget: Text(
                  'University Leaderboard',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIcon: CupertinoIcons.info,
                rightIconVisible: true,
                rightIconOnPress: () => showInfoSheet(
                    context, kLeaderboardInfoHeader, kLeaderboardInfoBody),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: PaintedHeader(context: context),
                            size: Size(MediaQuery.of(context).size.width, 125),
                          ),
                          Positioned.fill(
                            top: 30,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      child: LeaderboardCircleTile(
                                        minSize: 90,
                                        header: '2nd',
                                        body: 'SFU',
                                        desc: '123 pts',
                                      ),
                                    ),
                                    Flexible(
                                      child: LeaderboardCircleTile(
                                        minSize: 120,
                                        header: '1st',
                                        body: 'UVic',
                                        desc: '153 pts',
                                      ),
                                    ),
                                    Flexible(
                                      child: LeaderboardCircleTile(
                                        minSize: 90,
                                        header: '3rd',
                                        body: 'UBC',
                                        desc: '98 pts',
                                      ),
                                    ),
                                  ],
                                ),
                                // HERE
                                LineLayout(
                                  topPadding: 30,
                                  width: MediaQuery.of(context).size.width * .3,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      const SizedBox(height: 30),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          LeaderboardRectangleTile(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaintedHeader extends CustomPainter {
  PaintedHeader({required this.context});

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Theme.of(context).colorScheme.background;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, 0),
        height: size.height * 1.75,
        width: size.width,
      ),
      pi * 2,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
