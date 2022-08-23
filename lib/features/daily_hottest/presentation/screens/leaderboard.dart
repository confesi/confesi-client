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
                                        placing: '2nd',
                                        university: 'SFU',
                                        points: '123 pts',
                                      ),
                                    ),
                                    Flexible(
                                      child: LeaderboardCircleTile(
                                        minSize: 120,
                                        placing: '1st',
                                        university: 'UVic',
                                        points: '153 pts',
                                      ),
                                    ),
                                    Flexible(
                                      child: LeaderboardCircleTile(
                                        minSize: 90,
                                        placing: '3rd',
                                        university: 'UBC',
                                        points: '98 pts',
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
                                      const SizedBox(
                                          height:
                                              30), // Provides padding, while allowing the scroll to mee the horizontal line.
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          LeaderboardRectangleTile(
                                            placing: '4th',
                                            points: '86 pts',
                                            university:
                                                'University of Waterloo',
                                          ),
                                          LeaderboardRectangleTile(
                                            placing: '5th',
                                            points: '84 pts',
                                            university:
                                                'Washington State University',
                                          ),
                                          LeaderboardRectangleTile(
                                            placing: '6th',
                                            points: '62 pts',
                                            university: 'Harvard University',
                                          ),
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
